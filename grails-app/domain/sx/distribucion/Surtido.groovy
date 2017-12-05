package sx.distribucion

import sx.security.User

class Surtido {


    String	id

    String	origen

    String	entidad

    String	nombre

    String	comentario

    Boolean	entregaLocal	 = true

    Boolean	parcial	 = false

    Long	documento	 = 0

    String	tipoDeVenta

    Date	fecha

    Long	folioFac	 = 0

    User	userLastUpdate

    String	clasificacionVale

    User	asignado

    Date	iniciado

    Date	corteFin

    Date	corteInicio

    Date	asignacionCorte

    User cerro

    Date	cierreSurtido

    User	revisionUsuario

    Date	revision

    User	entrego

    Date	entregado

    User	depuradoUsuario

    Date	depurado

    Date cancelado

    User canceladoUser

    Boolean	reimportado	 = false

    BigDecimal	kilos	 = 0

    Integer	prods	 = 0

    BigDecimal	tiempoSurtido	 = 0

    String	comportamiento

    BigDecimal	kilosCorte	 = 0

    Integer	prodsCorte	 = 0

    User	cortador

    BigDecimal	tiempoCorte	 = 0


    Boolean	valido	 = false


    List cortes =[]

    List auxiliares= []


    static hasMany = [cortes:Corte,auxiliares :AuxiliarDeSurtido]


    static constraints = {

        comentario nullable: true
        asignado nullable: true
        iniciado nullable: true
        corteFin nullable: true
        corteInicio nullable: true
        asignacionCorte nullable: true
        cerro   nullable: true
        cierreSurtido nullable: true
        revisionUsuario nullable: true
        revision nullable: true
        entrego nullable: true
        entregado nullable: true
        depuradoUsuario nullable: true
        depurado nullable: true
        tiempoSurtido nullable: true
        comportamiento nullable: true
        kilosCorte nullable: true
        prodsCorte nullable: true
        cortador nullable: true
        tiempoCorte nullable: true
        comportamiento nullable: true
        entidad inList:['PST','FAC','SOL','TRS']
        cancelado nullable: true
        canceladoUser nullable: true
        cortes nullable: true
        auxiliares nullable: true

    }

    static mapping = {
        id generator: 'uuid'
        auxiliares cascade: "all-delete-orphan"
    }

    def getEstado(){
        if(!iniciado){
            if(cancelado)
                return 'CANCELADO'
            if(depurado)
                return 'DEPURADO'
            return 'PENDIENTE'
        }

        if(entregaLocal){

            if(iniciado){
               if(cancelado){
                    return 'CANCELADO'
                }else  if(depurado){
                    return 'DEPURADO'
                }else if(entregado){
                    return 'ENTREGADO'
                }else  if(iniciado && prodsCorte==0 && revision ==null){
                    return 'POR REVISAR'
                }else if(iniciado && prodsCorte==0 && revision !=null){
                    return 'POR ENTREGAR'
                }else if(iniciado && prodsCorte>0 && asignacionCorte==null){
                    return 'EN SURTIDO'
                }else if(iniciado && prodsCorte>0 && asignacionCorte!=null && corteInicio== null){
                    return 'POR CORTAR'
                }else if(corteInicio!=null && corteFin==null && revision== null){
                    return 'EN CORTE'
                }else if(corteInicio!=null && corteFin!=null && !empacadoFinEstado && revision== null){
                    return 'EN EMPAQUE'
                }else if(corteInicio!=null && corteFin!=null && empacadoFinEstado && revision== null){
                    return 'POR REVISAR'
                }else if(corteInicio!=null && corteFin!=null && empacadoFinEstado && revision!= null){
                    return 'POR ENTREGAR'
                }
                return 'EN SURTIDO'
            }

        }
        if(!entregaLocal){

            if(iniciado){
                if(cancelado){
                    return 'CANCELADO'
                }else if(depurado){
                    return 'DEPURADO'
                }else if(revision){
                    return 'REVISADO'
                }else /* if(iniciado && getCortes()==0 && entregado !=null){
                    return 'POR REVISAR'
                }else if(iniciado && getCortes()>0 && asignacionCorte==null){
                    return 'EN SURTIDO'
                }else if(iniciado && getCortes()>0 && asignacionCorte!=null && corteInicio== null){
                    return 'POR CORTAR'
                }else if(corteInicio!=null && corteFin==null && entregado== null){
                    return 'EN CORTE'
                }else if(corteInicio!=null && corteFin!=null && !empacadoFinEstado && entregado== null){
                    return 'EN EMPAQUE'
                }else  if(corteInicio!=null && corteFin!=null && empacadoFinEstado  && entregado== null){
                    return 'POR ENTREGAR'
                }else if(corteInicio!=null && corteFin!=null && empacadoFinEstado && revision== null){
                    return 'POR REVISAR'
                }*/
                return 'EN SURTIDO'
            }
        }
    }

    def getStatus(){
        if(entregado && entregaLocal){
            return 'ENTREGADO'
        }

        if(revision && !entregaLocal){
            return 'ENTREGADO'
        }

        if(prodsCorte>0){
            if(corteFin!=null)
                return 'POR ENTREGAR'
            if(corteInicio!=null)
                return 'EN CORTE'
            else
                return 'PENDIENTE'
        }else{
            return asignado?'POR ENTREGAR':'PENDIENTE'
        }
    }



}
