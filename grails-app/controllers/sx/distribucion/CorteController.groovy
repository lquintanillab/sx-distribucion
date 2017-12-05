package sx.distribucion


import sx.security.User
import  org.springframework.security.access.annotation.Secured
import sx.security.UserRole

class CorteController {

    def corteService

    @Secured(["hasAnyRole('ROLE_CORTADOR')"])
    def pendientes(int max){

       // params.sort='pedido'
        params.order='asc'

        def list=Corte.findAll("from Corte c where c.fin=null and c.surtido.cancelado=null order by c.surtido.documento")

        [corteInstanceList: list]
    }


    @Secured(["hasAnyRole('ROLE_CORTADOR')"])
    def entregarACorte(Corte corte){

        def cortador=getAuthenticatedUser()
        assert cortador,'No esta firmado al sistema'
        assert validarOperacionDeCortado(),'El sistema esta registrado sin rol de CORTADOR'
        assert corte.statusCorte=='PENDIENTE'

        String nip=params.nip
        if(!nip){
            flash.error="Digite su NIP para proceder con operacin"
            redirect action:'pendientes'
            return
        }
        def surtidor=User.findByNip(nip)
        if(!surtidor){
            flash.error="Operador no encontrado verifique su NIP "
            redirect action:'pendientes'
            return
        }
/*
      if(surtidor.username!=corte.surtidor){
        flash.error= "Esta partida solo la puede entregar a corte: $corte.surtidor no por $surtidor.username"
        redirect action:'pendientes'
        return
      }
*/
        corte.asignado=cortador
        corte.asignacion=new Date()

        println("REgistrando el corte")

        corte.save(flush:true)

        corteService.registrarAsignacionDeCorteEnSurtido corte
       // event('surtidoEntregadoACorte', corte)

        if(params.cortes){
            def adicionales=params.cortes.findAll({it.toLong()!=corte.id})
            adicionales.each{
                def ca=Corte.get(it)
                if(ca.surtidor==corte.surtidor ){
                    ca.asignado=cortador
                    ca.asignacion=new Date()
                    ca.save(flush:true)
                    //event('surtidoEntregadoACorte', ca)
                }
            }
            //print 'Surtidos adicionales: '+adicionales
        }

        println( "redireccionanda")
        log.info "Producto  $corte.producto.clave entregado  a  $cortador.username "
        flash.success= "Producto  $corte.producto.clave entregado  a  $cortador.username "

        //redirect controller: "home" ,action: "index"


        redirect action:'pendientes'
    }

    private  boolean validarOperacionDeCortado(){
        return getAuthenticatedUser().getAuthorities().find{it.authority=='ROLE_CORTADOR'}
    }

    @Secured(["hasAnyRole('ROLE_CORTADOR')"])
    def iniciarCorte2(Corte corte){
        //println 'Inicinado corte: '+params

        def cortador=getAuthenticatedUser()
        assert cortador,'No esta firmado al sistema'
        assert validarOperacionDeCortado(),'El sistema esta registrado sin rol de CORTADOR'
        assert corte.statusCorte=='PENDIENTE'

        corte.inicio=new Date()
        corte.empacadoInicio=corte.inicio
        corte.asignado=cortador
        corte.save(flush:true)
        //Actualizando el inicio del corte en surtido
        corteService.registrarInicioDeCorteEnSurtido corte
        //event('corteIniciado', corte)
        if(params.cortes){

            def adicionales=params.cortes.findAll({it.toLong()!=corte.id})
            adicionales.each{

                def ca=Corte.get(it)
                if(ca.asignado==corte.asignado && (ca.inicio==null) ){
                    ca.inicio=new Date()
                    ca.empacadoInicio=corte.inicio
                    ca.asignado=cortador.username
                    ca.save(flush:true)
                    //event('corteIniciado', ca)
                    corteService.registrarInicioDeCorteEnSurtido ca
                }
            }
            //print 'Surtidos adicionales: '+adicionales
        }

        log.info " Corte de producto  $corte.producto.clave iniciado por:$cortador.username "
        flash.success=  " Corte de producto  $corte.producto.clave iniciado por:$cortador.username "

        redirect action:'pendientes'
    }

    @Secured(["hasAnyRole('ROLE_CORTADOR')"])
    def terminarCorte2(Corte corte){
        assert corte, 'Corte nulo no puede ser terminado'
        assert corte.statusCorte=='EN CORTE','Corte con estatus incorrecto'
        def cortador=getAuthenticatedUser()
        corte.fin=new Date()
        //corte.asignado=cortador.username
        corte.save(flush:true)

        log.info "Corte terminado para  $corte.producto.clave entregado por:  $cortador.nombre "
        flash.success= "Corte terminado para  $corte.producto.clave Entregado por:  $cortador.nombre "

        if(params.cortes){ // cortes adicionales
            def adicionales=params.cortes.findAll({it.toLong()!=corte.id})
            adicionales.each{
                def ca=Corte.get(it)
                if(ca.asignado==corte.asignado && (ca.fin==null) ){
                    ca.fin=new Date()
                    //ca.asignado=cortador.username
                    ca.save(flush:true)
                    //println 'Registrando fin de corte.....'
                    //corteService.registrarFinDeCorteEnSurtido(ca)
                    //event('corteTerminado', ca)
                }
            }
            //print 'Surtidos adicionales: '+adicionales
        }
        def surt=corte.surtido
        def cortesPend= surt.cortes.findAll{it.fin==null}
        cortesPend.each{
            println"Corte"+it
        }
        if(!cortesPend){
            println "Ya  no hay mas cortes pendientes"
            corteService.registrarFinDeCorteEnSurtido(corte)
        }else
        {
            println "Todavia hay cortes pendientes"
        }
        redirect action:'pendientes'
    }

    @Secured(["hasAnyRole('ROLE_CORTADOR')"])
    def iniciarCorteGlobal(Corte corte){
        //println 'Inicinado corte: '+params

        def cortador=getAuthenticatedUser()
        assert cortador,'No esta firmado al sistema'
        assert validarOperacionDeCortado(),'El sistema esta registrado sin rol de CORTADOR'
        assert corte.statusCorte=='PENDIENTE'


        def surt=corte.surtido
        def parts= surt.cortes.findAll{it.inicio==null}
        parts.each{
            it.inicio=new Date()
            it.empacadoInicio=corte.inicio

            if(!it.asignado){
                it.asignado=cortador
                it.asignacion=new Date()
            }
            it.asignado=cortador

            it.save(flush:true)

        }

        //Actualizando el inicio del corte en surtido

        corteService.registrarAsignacionDeCorteEnSurtido corte
        corteService.registrarInicioDeCorteEnSurtido corte



        log.info " Corte de producto  $corte.producto.clave iniciado por:$cortador.username "
        flash.success=  " Corte de producto  $corte.producto.clave iniciado por:$cortador.username "

        redirect action:'pendientes'
    }

    @Secured(["hasAnyRole('ROLE_CORTADOR')"])
    def terminarCorteGlobal(Corte corte){
        assert corte, 'Corte nulo no puede ser terminado'
        assert corte.statusCorte=='EN CORTE','Corte con estatus incorrecto'
        def cortador=getAuthenticatedUser()



        def surt=corte.surtido
        def parts= surt.cortes.findAll{it.fin==null}
        parts.each{
            it.fin=new Date()
            //corte.asignado=cortador.username
            it.save(flush:true)
        }

        corteService.registrarFinDeCorteEnSurtido(corte)

        log.info "Corte terminado para  $corte.producto.clave entregado por:  $cortador.nombre "
        flash.success= "Corte terminado para  $corte.producto.clave Entregado por:  $cortador.nombre "



        redirect action:'pendientes'
    }

    @Secured(['permitAll'])
    def enProceso(Integer max,User cortador){
        //params.max = Math.min(max ?: 10, 100)
        //params.sort='pedido'
        //params.order='asc'

        def cortadores=UserRole.executeQuery("select l.user from UserRole l where l.role.authority='ROLE_CORTADOR'")

        if(cortador==null){
            flash.error="No hay cortador registrado"
            [corteInstanceList:[],corteInstanceCount:0,cortadores:cortadores]
            return
        }

        def query=Corte.where{asignado.username==cortador.username  }

        query=query.where{surtido.entregado==null  }
        def list = query.list(params).findAll{!it.surtido.cancelado && !it.surtido.depurado && it.surtido.entregado==null }


        [corteInstanceList:list
         // [corteInstanceList:query(params)
         ,corteInstanceCount:list.size(),cortadores:cortadores
         ,cortador:cortador]

    }



    @Secured(['permitAll'])
    def terminarEmpacado(Corte corte){


        def cortador=User.findByUsername(corte.asignado.username)
        assert corte.fin,'No se ha terminado de cortar por lo que no se puede terminar el empacado'

        String nip=params.nip
        if(!nip){
            flash.error="Digite su NIP para proceder con operacin"
            redirect action:'enProceso',params:[id:cortador.id]
            return
        }
        def empacador=User.findByNip(nip)
        if(!empacador){
            flash.error="Empacador no encontrado verifique su NIP "
            redirect action:'enProceso',params:[id:cortador.id]
            return
        }
        if(!empacador.getAuthorities().find{it.authority=='ROLE_EMPACADOR'}){
            flash.error="No tiene el ROL de EMPACADOR verifique su NIP "
            redirect action:'enProceso',params:[id:cortador.id]
            return
        }
        corte.empacador=empacador
        corte.empacadoFin=new Date()
        corte.save(flush:true)

        log.info "Empacado terminado para $corte.producto  "

        if(params.cortes){

            def adicionales=params.cortes.findAll({it.toLong()!=corte.id})

            adicionales.each{
                def ca=Corte.get(it)
                if( corte.pedido==ca.pedido && !ca.empacador && !ca.empacadoFin){
                    ca.empacador=empacador
                    ca.empacadoFin=corte.empacadoFin
                    ca.save(flush:true)
                    log.info "Empacado terminado para $ca.producto.clave  "
                }
            }

        }

        flash.success= "Empacado terminado para $corte.producto.clave  "
        redirect action:'enProceso',params:[id:cortador.id]

    }

    @Secured(['permitAll'])
    def terminarEmpacadoGlobal(Corte corte){
        println "Terminando empaque global para:  "+corte.surtido.documento
        def cortador=User.findByUsername(corte.asignado.username)
        assert corte.fin,'No se ha terminado de cortar por lo que no se puede terminar el empacado'

        String nip=params.nip
        if(!nip){
            flash.error="Digite su NIP para proceder con operacin"
            redirect action:'enProceso',params:[id:cortador.id]
            return
        }
        def empacador=User.findByNip(nip)
        if(!empacador){
            flash.error="Empacador no encontrado verifique su NIP "
            redirect action:'enProceso',params:[id:cortador.id]
            return
        }
        if(!empacador.getAuthorities().find{it.authority=='ROLE_EMPACADOR'}){
            flash.error="No tiene el ROL de EMPACADOR verifique su NIP "
            redirect action:'enProceso',params:[id:cortador.id]
            return
        }


        def surt=corte.surtido
        def parts= surt.cortes.findAll{ it.fin!=null && it.empacadoFin==null}
        if(parts){
            parts.each{
                println "actualizando partida del corte:  " +corte.id
                it.empacador=empacador
                it.empacadoFin=new Date()
                it.save(flush:true)
                flash.success= "Empacado terminado para $corte.surtido.documento "
            }
        }else{
            log.info "El surtido no tiene partidas con corte  "
            flash.success= "No se cerro el empaque  "
        }


        /*corte.empacador=empacador.username
        corte.empacadoFin=new Date()
        println "Corte salvado"
        corte.save(flush:true)*/



        log.info "Empacado terminado para $corte.producto.clave  "

        //flash.success= "Empacado terminado para $corte.producto  "
        redirect action:'enProceso',params:[id:cortador.id]

    }

    @Secured(['permitAll'])
    def agregarAuxiliar(){
        Corte corte=Corte.get(params.id)
        def cortador=User.findByUsername(corte.asignado.username)
        assert corte,'No existe el corte '+params.id
        String tipo=params.tipo
        assert tipo,'Auxiliar sin tipo no se puede generar'
        String nip=params.nip
        if(!nip){
            flash.error="Digite su NIP para agregar un auxiliar $tipo para el pedido $corte.pedido"
            redirect action:'enProceso',params:[id:cortador.id]
            return
        }
        def auxiliar=User.findByNip(nip)
        if(!auxiliar){
            flash.error="Operador no encontrado verifique su NIP "
            redirect action:'enProceso',params:[id:cortador.id]
            return
        }

        def auth="ROLE_"+tipo
        if(!auxiliar.getAuthorities().find{it.authority==auth}){
            flash.error="No tiene el ROL de $auth verifique su NIP "
            redirect action:'enProceso',params:[id:cortador.id]
            return
        }

        if(auxiliar.username==corte.asignado.username){
            flash.error="El corte ya esta asignado a: ($auxiliar.username) no puede ser auxiliar"
            redirect action:'enProceso',params:[id:cortador.id]
            return
        }

        if(corte.auxiliares.find{it.auxiliarCorte.username==auxiliar.username && it.tipo==tipo}){
            flash.error="$auxiliar.username ya esta registrado como auxiliar del corte/empaque"
            redirect action:'enProceso',params:[id:cortador.id]
            return
        }

        AuxiliarDeCorte auxiliarCorte=new AuxiliarDeCorte()

        auxiliarCorte.auxiliarCorte= auxiliar
        auxiliarCorte.tipo= tipo


        corte.addToAuxiliares(auxiliarCorte)
        corte.save(flush:true,failOnError:true)
        log.info "Cortador auxiliar $auxiliar.username asignado al  pedido: $corte.surtido.documento   "
        flash.success="Auxiliar $tipo $auxiliar.username asignado al  pedido: $corte.surtido.documento   "
        redirect action:'enProceso',params:[id:cortador.id]

    }


    @Secured(["hasAnyRole('ROLE_CORTADOR')"])
    def registrarMesaDeEmpaque(){

        def cortador=getAuthenticatedUser()
        assert validarOperacionDeCortado(),'El sistema esta registrado sin rol de CORTADOR'

        def fe=new Date().format('dd/MM/yyyy')

        def fecha= new Date(fe)

        def mesa=MesaDeEmpaque.findByCortadorAndFecha(cortador,fecha)


        if(mesa){
            println("Ya esta la mesa")
            flash.error="Ya esta la mesa de empaque registrada para: ${cortador.username} (${fecha.format("dd/MM/yyyy")})"
            redirect action:'pendientes'
            return
        }else{
            println("no esta la mesa")


            mesa= new MesaDeEmpaque()

            mesa.cortador=cortador
            mesa.fecha=fecha

            mesa.save(failOnError: true, flush: true)

            flash.succes="Se creo la mesa de empaque "
            redirect action:'pendientes'
            return
        }



    }


    @Secured(['permitAll'])
    def asignarseAMesaDeEmpaque(){

        def cortador=User.get(params.id)

        def fe=new Date().format('dd/MM/yyyy')

        def fecha= new Date(fe)

        def mesa = MesaDeEmpaque.findByCortadorAndFecha(cortador,fecha)

        if(!mesa){
            flash.error="No hay mesa registrada para : ${cortador.username}"
            redirect action:'enProceso',params:[id:params.id]
            return

        }else{

            String nip=params.nip
            if(!nip){
                flash.error="Digite su NIP para asignarse a mesa de empaque"
                redirect action:'enProceso',params:[id:params.id]
                return
            }

            def surtidor=User.findByNip(nip)

            if(!surtidor){
                flash.error="Operador no encontrado verifique su NIP "
                redirect action:'enProceso',params:[id:params.id]
                return
            }
            if(!surtidor.getAuthorities().find{it.authority=='ROLE_EMPACADOR'}){
                flash.error="No tiene el ROL de Empacador verifique su NIP "
                redirect action:'enProceso',params:[id:params.id]
                return
            }

            for(int i=1 ; i<=8 ; i++) {

                def column = "empacador" + i

                if(mesa[column] == null){

                    switch (i){
                        case 1:
                            mesa.empacador1 = surtidor
                            break
                        case 2:
                            mesa.empacador2 = surtidor
                            break
                        case 3:
                            mesa.empacador3 = surtidor
                            break
                        case 4:
                            mesa.empacador4 = surtidor
                            break
                        case 5:
                            mesa.empacador5 = surtidor
                            break
                        case 6:
                            mesa.empacador6 = surtidor
                            break
                        case 7:
                            mesa.empacador7 = surtidor
                            break
                        case 8:
                            mesa.empacador8 = surtidor
                            break

                        default:
                            break
                    }
                    break
                }else{
                    if(mesa[column]==surtidor){
                        flash.error="Usuario ya asignado a esta mesa "
                        redirect action:'enProceso',params:[id:params.id]
                        return
                    }
                }

            }

            mesa.save(failOnError: true, flush: true)

        }
        redirect action:'enProceso',params:[id:params.id]
        return
    }


    @Secured(['permitAll'])
    def salirDeMesaDeEmpaque(){

        def cortador=User.get(params.id)

        def fe=new Date().format('dd/MM/yyyy')

        def fecha= new Date(fe)

        def mesa = MesaDeEmpaque.findByCortadorAndFecha(cortador,fecha)

        if(!mesa){
            flash.error="No hay mesa registrada para : ${cortador.username}"
            redirect action:'enProceso',params:[id:params.id]
            return

        }else{
            String nip=params.nip
            if(!nip){
                flash.error="Digite su NIP para salir de mesa de empaque"
                redirect action:'enProceso',params:[id:params.id]
                return
            }

            def surtidor=User.findByNip(nip)

            if(!surtidor){
                flash.error="Operador no encontrado verifique su NIP "
                redirect action:'enProceso',params:[id:params.id]
                return
            }
            if(!surtidor.getAuthorities().find{it.authority=='ROLE_EMPACADOR'}){
                flash.error="No tiene el ROL de Empacador verifique su NIP "
                redirect action:'enProceso',params:[id:params.id]
                return
            }
            for(int i=1 ; i<=8 ; i++) {

                def column = "empacador" + i

                if (mesa[column] == surtidor) {

                    switch (i) {
                        case 1:
                            mesa.empacador1 = null
                            break
                        case 2:
                            mesa.empacador2 = null
                            break
                        case 3:
                            mesa.empacador3 = null
                            break
                        case 4:
                            mesa.empacador4 = null
                            break
                        case 5:
                            mesa.empacador5 = null
                            break
                        case 6:
                            mesa.empacador6 = null
                            break
                        case 7:
                            mesa.empacador7 = null
                            break
                        case 8:
                            mesa.empacador8 = null
                            break

                        default:
                            break
                    }
                    break
                }


            }

            mesa.save(failOnError: true, flush: true)
        }

        redirect action:'enProceso',params:[id:params.id]
        return
    }

    @Secured(['permitAll'])
    def terminarEmpacadoMesa(Corte corte){

        def cortador=User.findByUsername(corte.asignado.username)
        assert corte.fin,'No se ha terminado de cortar por lo que no se puede terminar el empacado'

        String nip=params.nip
        if(!nip){
            flash.error="Digite su NIP para proceder con operacin"
            redirect action:'enProceso',params:[id:cortador.id]
            return
        }
        def empacador=User.findByNip(nip)
        if(!empacador){
            flash.error="Empacador no encontrado verifique su NIP "
            redirect action:'enProceso',params:[id:cortador.id]
            return
        }
        if(!empacador.getAuthorities().find{it.authority=='ROLE_EMPACADOR'}){
            flash.error="No tiene el ROL de EMPACADOR verifique su NIP "
            redirect action:'enProceso',params:[id:cortador.id]
            return
        }


        agregarEmpacadorMesa(corte, empacador)


        log.info "Empacado terminado para $corte.producto  "

        if(params.cortes){

            def adicionales=params.cortes.findAll({it.toLong()!=corte.id})

            adicionales.each{
                def ca=Corte.get(it)
                if( corte.pedido==ca.pedido && !ca.empacador && !ca.empacadoFin){
                    ca.empacador=empacador
                    ca.empacadoFin=corte.empacadoFin
                    ca.save(flush:true)
                    log.info "Empacado terminado para $ca.producto.clave  "
                }
            }

        }

        flash.success= "Empacado terminado para $corte.producto.clave "
        redirect action:'enProceso',params:[id:cortador.id]

    }

    def agregarEmpacadorMesa(Corte corte, User empacador){

        def fe=new Date().format('dd/MM/yyyy')

        def fecha= new Date(fe)

        def mesa = MesaDeEmpaque.findByCortadorAndFecha(corte.asignado,fecha)

        if(!mesa){
            flash.error="No hay mesa registrada para : ${cortador.username}"
            redirect action:'enProceso',params:[id:cortador.id]
            return

        }else{

            corte.empacador=empacador
            corte.empacadoFin=new Date()


            for(int i=1 ; i<=8 ; i++) {

                def column = "empacador" + i

                println column

                if (mesa[column] != null){

                    println(mesa[column])
                    def auxiliar= new AuxiliarDeCorte()

                    auxiliar.corte=corte
                    auxiliar.auxiliarCorte=mesa[column]
                    auxiliar.tipo='EMPACADOR'

                    corte.addToAuxiliares(auxiliar)
                    println("Salvando empacador mesa"+auxiliar)
                    corte.save(flush:true)


                }

            }

        }

    }


}
