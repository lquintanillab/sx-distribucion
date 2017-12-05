package sx.distribucion

import grails.databinding.BindingFormat
import grails.validation.Validateable
import groovy.transform.ToString
import org.springframework.security.access.annotation.Secured


@Secured(["hasAnyRole('ROLE_GERENTE')"])
class SurtidoAnalisisController {

    def analisis(Surtido surtido){

        //def q=Corte.where {surtidoDet.surtido==surtido}
       def cortes= [] //q.list()

        [surtidoInstance:surtido,cortes:cortes]
    }

    def administracion(){

    }

    def dashboard(){

    }

    def filtrar(){

    }

}


@ToString(includeNames=true,includePackage=false)
class SearchCommand {

    Long pedido

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
        pedido nullable:true
        surtidor nullable:true
    }

    Periodo toPeriodo(){
        return new Periodo(fechaInicial,fechaFinal)
    }


}


class PeriodoCommand{
    Date fechaInicial
    Date fechaFinal

}

