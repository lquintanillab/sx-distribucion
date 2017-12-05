package sx.distribucion

import groovy.transform.ToString
import groovy.transform.EqualsAndHashCode

@ToString(includeNames=true,includePackage=false)
@EqualsAndHashCode(includes='nombre')
class AuxiliarDeSurtido {

    String nombre

    Date dateCreated

    Surtido surtido



    static constraints = {

    }


}
