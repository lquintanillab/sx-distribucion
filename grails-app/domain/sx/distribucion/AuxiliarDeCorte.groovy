package sx.distribucion

import sx.security.User

class AuxiliarDeCorte {

    String	id

    Corte	corte

    User auxiliarCorte

    String	tipo

    Date	dateCreated



    static constraints = {
        tipo inList:['EMPACADOR','CORTADOR']
    }

    static  mapping = {
        id generator: 'uuid'
    }
}
