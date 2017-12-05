package sx.distribucion

import groovy.transform.ToString
import groovy.transform.EqualsAndHashCode

@ToString(includes='id,clave,decripcion',includeNames=true,includePackage=false)
@EqualsAndHashCode(includes='clave,descripcion')
class Producto {

    String id

    String clave

    String descripcion

    String unidad

    String	modoVenta

    String codigo

    Boolean activo = true

    BigDecimal kilos = 0

    BigDecimal gramos = 0

    BigDecimal calibre = 0

    Integer caras = 0

    String color

    String acabado

    String presentacion

    Boolean nacional = true

    BigDecimal ancho

    BigDecimal largo

    Boolean deLinea = true

    BigDecimal precioContado  = 0.0

    BigDecimal precioCredito = 0.0

    BigDecimal m2XMillar = 0.0

    Boolean inventariable = true

    String	comentario

    Date dateCreated

    Date lastUpdated

    static constraints = {

        unidad minSize:2,maxSize:10
        codigo nullable:true
        caras range:0..2
        color nullable:true, maxSize:15
        acabado nullable:true, maxSize:20
        presentacion inList:['EXTENDIDO','CORTADO','BOBINA','ND']
        ancho nullable:true
        largo nullable:true
        modoVenta inList: ['B','N']
        comentario nullable: true
    }

    static mapping={
        id generator:'uuid'
    }


}
