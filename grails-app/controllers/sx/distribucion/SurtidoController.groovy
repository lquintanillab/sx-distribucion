package sx.distribucion

import sx.security.User
import  org.springframework.security.access.annotation.Secured



@Secured(['permitAll'])
class SurtidoController {

    def surtidoService


    def pendientes() {

        params.order='asc'
        def query=Surtido.where{ (iniciado==null  && entidad=='FAC')}

      [surtidoInstanceList: query.list(),surtidoInstanceCount:query.count()]
        //[surtido: Surtido.get('8a8a81d45fa7386e015fa752a6d00003x')]

    }


    def documentosPendientes() {
        params.order='asc'
        def query=Surtido.where{ (iniciado==null  && entidad!='FAC')}

        [surtidoInstanceList: query.list(),surtidoInstanceCount:query.count()]
        //[surtido: Surtido.get('8a8a81d45fa7386e015fa752a6d00003x')]
    }


    def enProceso(){

     /*
        params.max = Math.min(max ?: 10, 100)
        params.sort='pedidoCreado'
        params.order='asc'
*/
        def query =Surtido.where{iniciado!=null && asignado!=null && ((entregaLocal==true && entregado==null)||(entregaLocal==false && revision==null)) }
        [surtidoInstanceList:query.list(params),surtidoInstanceCount:query.count()]
    }

    def porEntregar() {
        //params.sort='pedidoCreado'
        params.order='asc'

        def list=Surtido.where{entregaLocal==true && cancelado==null && entregado==null}.list(params)

        [surtidoInstanceList: list]


    }


    def asignar(Surtido surtido){
        String nip=params.nip
        if(!nip){
            flash.error="Digite su NIP para asignar pedido $surtido.documento"
            if(surtido.entidad=='FAC'){
                redirect action:'pendientes'
            }else{
                redirect action:'documentosPendientes'
            }
            return
        }
        def user=User.findByNipAndEnabled(nip,true)
        if(!user){
            flash.error="Operador no encontrado verifique su NIP "
            if(surtido.entidad=='FAC'){
                redirect action:'pendientes'
            }else{
                redirect action:'documentosPendientes'
            }
            return
        }
        if(!user.getAuthorities().find{it.authority=='ROLE_SURTIDOR'}){
            flash.error="No tiene el ROL de SURTIDOR verifique su NIP "
            if(surtido.entidad=='FAC'){
                redirect action:'pendientes'
            }else{
                redirect action:'documentosPendientes'
            }
            return
        }

        surtido.asignado=user
        surtido.iniciado=new Date()
      /*  if(!surtido.autorizacionSurtido){
            surtido.autorizacionSurtido=new Date()
            surtido.autorizoSurtir=user.username
        }*/
        surtido.save(flush:true,failOnError:true)

        if(params.surtidos){
            def adicionales=params.surtidos.findAll({it.toLong()!=surtido.id})
            adicionales.each{
                def s2=Surtido.get(it.toLong())
                s2.asignado=user.username
                s2.iniciado=new Date()

                if(!s2.autorizacionSurtido){
                    s2.autorizacionSurtido=new Date()
                    s2.autorizoSurtir=user.username
                }

                s2.save(flush:true,failOnError:true)

            }
            //print 'Surtidos adicionales: '+adicionales
        }
        log.info "Surtido de pedido: $surtido.documento asignado a  $user.nombre "
        flash.success="Surtido de pedido: $surtido.documento asignado a  $user.nombre "
        if(surtido.entidad=='FAC'){
            redirect action:'pendientes'
        }else{
            redirect action:'documentosPendientes'
        }


    }

    def asignacionManual(Surtido surtido){
        String nip=params.nip
        if(!nip){
            flash.error="Digite su NIP para asignar pedido $surtido.documento"

            if(surtido.entidad=='FAC'){
                redirect action:'pendientes'
            }else{
                redirect action:'documentosPendientes'
            }
            return
        }
        def user=User.findByNip(nip)
        if(!user){
            flash.error="Operador no encontrado"
            if(surtido.entidad=='FAC'){
                redirect action:'pendientes'
            }else{
                redirect action:'documentosPendientes'
            }
            return
        }
        if(!user.getAuthorities().find{it.authority=='ROLE_SUPERVISOR_SURTIDO'}){
            flash.error="No tiene el ROL de SUPERVISOR_SURTIDO  "

            if(surtido.entidad=='FAC'){
                redirect action:'pendientes'
            }else{
                redirect action:'documentosPendientes'
            }
            return
        }

        def surtidor=User.get(params.surtidor)

        surtido.asignado=surtidor
        surtido.iniciado=new Date()
       // surtido.autorizacionSurtido=new Date()
       // surtido.autorizoSurtir='FAC'
        surtido.save(flush:true,failOnError:true)

        if(params.surtidos){
            def adicionales=params.surtidos.findAll({it.toLong()!=surtido.id})
            adicionales.each{
                def s2=Surtido.get(it.toLong())
                s2.asignado=surtidor
                s2.iniciado=new Date()
                s2.save(flush:true,failOnError:true)

            }
            //print 'Surtidos adicionales: '+adicionales
        }
        log.info "Surtido de pedido: $surtido.documento asignado a  $surtidor.nombre "
        flash.success="Surtido de pedido: $surtido.documento asignado a  $surtidor.nombre "

        if(surtido.entidad=='FAC'){
            redirect action:'pendientes'
        }else{
            redirect action:'documentosPendientes'
        }
    }


    def cancelarAsignacion(Surtido surtido) {
        assert surtido.asignado,'El surtido no ha sido asignado por lo que no se puede canclear la asignacion'
        assert !surtido.cancelado,'El surtido ha sido cancleado no se puede eliminar la asignacion'
        String nip=params.nip
        if(!nip){
            flash.error="Digite su NIP para cancelar la asignacion del surtido: $surtido.documento"
            redirect action:'enProceso'
            return
        }
        def surtidor=User.findByNip(nip)
        if(!surtidor){
            flash.error="Operador no encontrado verifique su NIP "
            redirect action:'enProceso'
            return
        }

        if(!surtidor.getAuthorities().find{it.authority=='ROLE_SUPERVISOR_SURTIDO'}){
            flash.error="No tiene el ROL de SUPERVISOR_SURTIDO verifique su NIP "
            redirect action:'pendientes'
            return
        }

        /* if(surtidor.username!=surtido.asignado){
          flash.error="La asignacion del surtido para el pedido: $surtido.pedido  solo puede ser cancelada por:$surtido.asignado"
          redirect action:'enProceso'
          return
        }*/
        surtido.asignado=null
        surtido.iniciado=null
        //surtido.auxiliares.clear()
        //surtido.auxiliares.collect().each { item.removeFromAuxiliares(it) }
        surtido.save(flush:true,failOnError:true)
        redirect action:'enProceso'
    }

    def agregarAuxiliar(Surtido surtido){
        String nip=params.nip
        if(!nip){
            flash.error="Digite su NIP para agregar un auxiliar de surtido para el pedido $surtido.documento"
            redirect action:'enProceso'
            return
        }
        def surtidor=User.findByNip(nip)



        if(!surtidor){
            flash.error="Operador no encontrado verifique su NIP "
            redirect action:'enProceso'
            return
        }
        if(!surtidor.getAuthorities().find{it.authority=='ROLE_SURTIDOR'}){
            flash.error="No tiene el ROL de SURTIDOR verifique su NIP "
            redirect action:'enProceso'
            return
        }
        if(surtidor==surtido.asignado){
            flash.error="El surtido ya esta asignado a: ($surtidor.username) no puede ser auxiliar"
            redirect action:'enProceso'
            return
        }
        if(surtido.auxiliares.find{it.nombre==surtidor.username}){
            flash.error="Auxiliar ya asignado al pedido $surtido.documento ($surtidor.username) "
            redirect action:'enProceso'
            return
        }

        AuxiliarDeSurtido auxiliar=new AuxiliarDeSurtido()

        auxiliar.nombre= surtidor.username
        auxiliar.dateCreated= new Date()

        surtido.addToAuxiliares(auxiliar)
        surtido.save(flush:true,failOnError:true)
        log.info "Surtido auxiliar $surtidor.username asignado al  pedido: $surtido.documento   "
        flash.success="Surtido auxiliar $surtidor.username asignado al  pedido: $surtido.documento   "
        redirect action:'enProceso'

    }


    def revizarSurtido(Surtido surtido){


        String nip=params.nip
        if(!nip){
            flash.error="Digite su NIP para proceder con operacion"
            if(!surtido.entregaLocal){
                redirect action:'porEntregarEnvio'
            }else{
                redirect action:'porEntregar'
            }
            return
        }
        def supervisor=User.findByNip(nip)
        def userDefault=User.get(1)
        if(!supervisor){
            flash.error="Supervisor no encontrado verifique su NIP "
            if(!surtido.entregaLocal){
                redirect action:'porEntregarEnvio'
            }else{
                redirect action:'porEntregar'
            }
            return
        }
        if(!supervisor.getAuthorities().find{it.authority=='ROLE_SUPERVISOR_ENTREGA'}){
            flash.error="No tiene el ROL de SUPERVISOR_ENTREGA verifique su NIP "
            if(!surtido.entregaLocal){
                redirect action:'porEntregarEnvio'
            }else{
                redirect action:'porEntregar'
            }
            return
        }
        surtido.revisionUsuario=supervisor
        surtido.revision=new Date()
        if(surtido.cierreSurtido==null){
            surtido.cierreSurtido=new Date()
            surtido.cerro=userDefault
        }

        if(!surtido.asignado){
            surtido.iniciado=new Date()
            surtido.asignado =userDefault
        }
        if(!surtido.entregaLocal && surtido.entrego== null){
            surtido.entrego=userDefault
            surtido.entregado=new Date()
        }

        surtido.save(flush:true)
        //   event('surtidoRevizado',surtido.id)

        surtidoService.registrarCortePorOmision(surtido)

        if(params.surtidos){
            def adicionales=params.surtidos.findAll({it.toLong()!=surtido.id})
            adicionales.each{
                def s2=Surtido.get(it.toLong())
                if(s2.entregaLocal){
                    s2.revisionUsuario=supervisor.username
                    s2.revision=new Date()
                    s2.save(flush:true)
                    event('surtidoRevizado',surtido.id)
                }
            }
        }

        log.info "Surtido de pedido: $surtido.documento revizado por  $supervisor.username "
        flash.success="Surtido de pedido: $surtido.documento entregado por  $supervisor.username "
        if(!surtido.entregaLocal){
            redirect action:'porEntregarEnvio'
        }else{
            redirect action:'porEntregar'
        }

    }

    def entregarSurtido(Surtido surtido){

        String nip=params.nip
        if(!nip){
            flash.error="Digite su NIP para proceder con operacin"
            if(!surtido.entregaLocal){
                redirect action:'porEntregarEnvio'
            }else{
                redirect action:'porEntregar'
            }
            return
        }
        def surtidor=User.findByNipAndEnabled(nip,true)
        def userDefault=User.get(1)
        if(!surtidor){
            flash.error="Operador no encontrado verifique su NIP "
            if(!surtido.entregaLocal){
                redirect action:'porEntregarEnvio'
            }else{
                redirect action:'porEntregar'
            }
            return
        }
        if(!surtidor.getAuthorities().find{it.authority=='ROLE_SURTIDOR'}){
            flash.error="No tiene el ROL de SURTIDOR verifique su NIP "
            if(!surtido.entregaLocal){
                redirect action:'porEntregarEnvio'
            }else{
                redirect action:'porEntregar'
            }
            return
        }


        surtido.entrego=surtidor
        surtido.entregado=new Date()
        if (!surtido.entregaLocal && !surtido.cierreSurtido) {
            surtido.cierreSurtido=surtido.entregado
            surtido.cerro =surtidor
        }
        if(!surtido.asignado){
            surtido.iniciado=surtido.entregado
            surtido.asignado =userDefault
        }
        surtido.save(flush:true)

        surtidoService. registrarCortePorOmision(surtido)
//      event('surtidoEntregado',surtido.id)
        log.info "Surtido de pedido: $surtido.documento entregado por  $surtidor.nombre "
        flash.success="Surtido de pedido: $surtido.documento entregado por  $surtidor.nombre "

        if(params.surtidos){
            println 'Estoy dentro de la Seleccion Multiple'
            def adicionales=params.surtidos.findAll({it.toLong()!=surtido.id})
            adicionales.each{

                def ca=Surtido.get(it)
                println 'Seleccion Multiple'+it
                surtido.entrego=surtidor
                surtido.entregado=new Date()
                ca.save(flush:true)

            }
        }

        if(!surtido.entregaLocal){
            redirect action:'porEntregarEnvio'
        }else{
            redirect action:'porEntregar'
        }

    }


    def porEntregarEnvio() {
        //params.sort='pedidoCreado'
        params.order='asc'

        def list=Surtido.where{entregaLocal==false && depurado==null  && cancelado==null && revision==null}.list(params)

        [surtidoInstanceList: list]

    }

    def cerrarSurtido(Surtido surtido){
        // assert surtido.status=='POR ENTREGAR','El surtido no esta listo para Cerrar Status: '+surtido.getStatus()
        String nip=params.nip
        if(!nip){
            flash.error="Digite su NIP para proceder con operacin"
            if(!surtido.entregaLocal){
                redirect action:'porEntregarEnvio'
            }else{
                redirect action:'porEntregar'
            }
            return
        }
        def surtidor=User.findByNipAndEnabled(nip,true)
        def userDefault=User.get(1)
        if(!surtidor){
            flash.error="Operador no encontrado verifique su NIP "
            if(!surtido.entregaLocal){
                redirect action:'porEntregarEnvio'
            }else{
                redirect action:'porEntregar'
            }
            return
        }
        if(!surtidor.getAuthorities().find{it.authority=='ROLE_SURTIDOR'}){
            flash.error="No tiene el ROL de SURTIDOR verifique su NIP "
            if(!surtido.entregaLocal){
                redirect action:'porEntregarEnvio'
            }else{
                redirect action:'porEntregar'
            }
            return
        }



        /* if (surtido.formaDeEntrega=='ENVIO' && (surtido.cortes==0 || surtido.cortes==surtido.partidas.count{it.descripcion!='CORTE' && it.descripcion!='M A N I O B R A'})) {
             surtido.entrego=surtidor.username
             surtido.entregado=new Date()
          }*/
        surtido.cierreSurtido=new Date()
        surtido.cerro =surtidor

        if(!surtido.asignado){

            surtido.iniciado=surtido.cierreSurtido
            surtido.asignado =userDefault
        }
        surtido.save(flush:true)
        //event('surtidoEntregado',surtido.id)
        log.info "Surtido de pedido: $surtido.documento entregado por  $surtidor.nombre "
        flash.success="Surtido de pedido: $surtido.documento entregado por  $surtidor.nombre "

        if(params.surtidos){

            def adicionales=params.surtidos.findAll({it.toLong()!=surtido.id})
            adicionales.each{

                def ca=Surtido.get(it)
                println 'Seleccion Multiple'+it
                //  surtido.entrego=surtidor.username
                surtido.cierreSurtido=new Date()
                ca.save(flush:true)

            }
        }


        if(!surtido.entregaLocal){
            redirect action:'porEntregarEnvio'
        }else{
            redirect action:'porEntregar'
        }

    }


}
