package sx.distribucion


import sx.security.User

class Corte {

    String	id

    InstruccionCorte instruccionDeCorte

    Producto producto

    User	asignado

    User	empacador

    User	canceladoUsuario

    Date	inicio

    Date	fin

    Date	empacadoInicio

    Date	empacadoFin

    Date	cancelado

    Date	asignacion

    Surtido surtido

    List auxiliares = []

    static belongsTo = [surtido: Surtido]

    static hasMany=[auxiliares:AuxiliarDeCorte]

    static constraints = {

        instruccionDeCorte nullable: true
        asignado nullable: true
        empacador nullable: true
        canceladoUsuario nullable: true
        inicio nullable: true
        fin nullable: true
        empacadoFin nullable: true
        empacadoInicio nullable: true
        cancelado nullable: true
        asignacion nullable: true

    }



    def getStatus(){
        if(empacadoFin)
            return 'EMPACADO'
        else if(empacadoInicio)
            return 'EN EMPACADO'
        else if(fin)
            return 'CORTADO'
        else if(asignado)
            return 'EN CORTE'
        else
            return 'PENDIENTE'

    }

    def getSurtidor(){
        return surtido.asignado
    }

    def getStatusCorte(){
        if(fin){
            return 'TERMINADO'
        }else if(inicio){
            return 'EN CORTE'
        }else
            return 'PENDIENTE'
    }

    def getStatusEmpaque(){
        if(empacadoFin)
            return 'EMPACADO'
        else if(empacadoInicio)
            return 'EN EMPACADO'
        else
            return 'PENDIENTE'
    }

    static mapping = {
        auxiliares cascade: "all-delete-orphan"
        cancelado type:'date'

    }
}
