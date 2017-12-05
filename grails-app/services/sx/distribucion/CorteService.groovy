package sx.distribucion

import grails.gorm.transactions.Transactional
import sx.security.User

@Transactional
class CorteService {

    def registrarAsignacionDeCorteEnSurtido(Corte corte){
        def surtido=corte.surtido
        def userDefault=User.get(1)
        def surtidoInit=Surtido.get(surtido.id)
        if(surtido.asignacionCorte==null){
            surtido.asignacionCorte=corte.asignacion
            if(!surtido.asignado){
                surtido.iniciado=surtido.asignacionCorte
                surtido.asignado =userDefault
            }
            surtido.save(flush:true)
        }
    }

    def registrarInicioDeCorteEnSurtido(Corte corte){
        def surtido=corte.surtido
        def userDefault=User.get(1)
        if(surtido.corteInicio==null){
            surtido.corteInicio=corte.inicio
            if(!surtido.asignado){
                surtido.iniciado=surtido.asignacionCorte
                surtido.asignado =userDefault
            }
            surtido.save(flush:true)
        }
    }

    def registrarFinDeCorteEnSurtido(Corte corte){

        def surtido=corte.surtido
        log.info 'Actualizando  fin del proceso de corte en el surtido '+surtido.id
        surtido.corteFin=new Date()
        surtido.save(flush:true)
    }

}
