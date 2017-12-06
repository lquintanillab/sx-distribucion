package sx.distribucion

import grails.databinding.BindingFormat
import grails.validation.Validateable
import groovy.transform.ToString
import org.springframework.security.access.annotation.Secured
import grails.converters.JSON


@Secured(["hasAnyRole('ROLE_GERENTE')"])
class SurtidoAnalisisController {



    def beforeInterceptor = {
        if(!session.periodoDeAnalisis){
            session.periodoDeAnalisis=new Date()
        }
    }


    def filtrar(SearchCommand command){

        if(!command.fechaInicial)
            command.fechaInicial=new Date()
        if(!command.fechaFinal)
            command.fechaFinal=new Date()


        def fe=new Date().format('dd/MM/yyyy')

        def fechaIni= new Date(fe)


        def q = Surtido.executeQuery("from Surtido s where (date(fecha) >= ? and date(fecha)<= ?) or (date(iniciado)>= ? and date(iniciado)<= ?  ) ",[command.fechaInicial,command.fechaFinal,command.fechaInicial,command.fechaFinal])

        if(command.surtidor){
            q = Surtido.where {
                println "Buscando por surtidor y fecha"
                asignado.username == command.surtidor &&  fecha >= command.fechaInicial && fecha <= command.fechaFinal
            }
        }
        //Ejemplo excluyente
        if( command.documento){
            println "Buscando por pedido"
            q = Surtido.where {
                documento==command.documento
        }
            }

        //params.sort='iniciado'
        //  params.order='asc'
        [surtidoInstanceList:q ,searchCommand:command]

        }

    def cambiarPeriodo(){
        def fecha=params.date('fecha', 'dd/MM/yyyy')
        session.periodoDeAnalisis=fecha
        redirect(uri: request.getHeader('referer') )
    }

    def analisis(Surtido surtido){

        //def q=Corte.where {surtidoDet.surtido==surtido}
       def cortes= [] //q.list()

        [surtidoInstance:surtido,cortes:cortes]
    }

    def administracion(){

    }

    def dashboard(){

    }

    def buscarPedido(){

        //def pedidos=Surtido.findAllByPedidoIlike(params.term+"%",[max:50,sort:"pedido",order:"desc"])
        def term=params.long('term')
        def query=Surtido.where{
            (documento>=term)
        }

        def pedidos=query.list(max:30, sort:"pedido",order:'asc')

        def pedidosList=pedidos.collect { surtido ->
            def label="Surtido $surtido.id Pedido: $surtido.documento"
            [id:surtido.documento,label:label,value:label]
        }
        def res = pedidosList as JSON
        render res
    }


}


@ToString(includeNames=true,includePackage=false)
class SearchCommand {

    Long documento

    String surtidor

    @BindingFormat('dd/MM/yyyy')
    Date fechaInicial //= new Date()-30

    @BindingFormat('dd/MM/yyyy')
    Date fechaFinal //=new Date()

    String cliente

    static constraints={
        fechaInicial nullable:true
        fechaFinal nullable:true
        cliente  nullable:true
        documento nullable:true
        surtidor nullable:true
    }

    Periodo toPeriodo(){
        return new Periodo(fechaInicial,fechaFinal)
    }


}




