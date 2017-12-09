package sx.distribucion

import java.math.MathContext
import java.math.RoundingMode

class CalcularCorte {



   def  calcularCorte(def anchoP,def largoP, def anchoC, def largoC) {


        CalculoCorte optimo;

        CalculoCorte corteH= new CalculoCorte();

        CalculoCorte corteV= new CalculoCorte();

        CalculoCorte corteHV= new CalculoCorte();

        CalculoCorte corteVH= new CalculoCorte();

        corteV.calcularCorte(largoP,anchoP,anchoC,largoC);
        corteH.calcularCorte(anchoP,largoP,anchoC,largoC);

        if((corteH.getTotal().compareTo(corteV.getTotal()))  ==  -1){
            optimo=corteV;
            corteHV=corteHV.calcularCorteOptimo( largoP,anchoP,anchoC,largoC,optimo);
            corteVH=corteVH.calcularCorteOptimo( anchoP,largoP ,anchoC, largoC,optimo);
        }else{
            optimo=corteH;
            corteHV=corteHV.calcularCorteOptimo( anchoP,largoP ,anchoC, largoC,optimo);
            corteVH=corteVH.calcularCorteOptimo( largoP,anchoP ,anchoC, largoC,optimo);
        }

        if(optimo.getTotal().intValue()<corteHV.getTotal().intValue()){
            optimo=corteHV;

        }

        if(optimo.getTotal().intValue()<corteVH.getTotal().intValue()){
            optimo=corteVH;

        }

        println("Res : "+corteH.getTotal().compareTo(corteV.getTotal()));
        println("Total Vertical : "+corteV.getTotal());
        println("Total Horizontal : "+corteH.getTotal());
        println("Total optimo : "+optimo.getTotal());

        println("------------------------------");


        println("Total Vertical : "+corteV.getTotal());
        println("Tamanos V : "+corteV.getTamanosL() +" X "+corteV.getTamanosA() );
        println("Area Corte  : "+corteV.getAnchoCorte() +" X "+corteV.getLargoCorte()+" = "+ corteV.getAnchoCorte()*corteV.getLargoCorte());
        println("Tamanos H : "+corteV.getTamanosLS() +" X "+corteV.getTamanosAS() );
      //  println("Area Corte  : "+corteV.getAnchoCorteS() +" X "+corteV.getLargoCorteS()+" = "+ corteV.getAnchoCorteS()*corteV.getLargoCorteS());

        println("------------------------------");


        println("Total Horizonta : "+corteH.getTotal());
        println("Tamanos V : "+corteH.getTamanosL() +" X "+corteH.getTamanosA() );
        println("Area Corte  : "+corteH.getAnchoCorte() +" X "+corteH.getLargoCorte()+" = "+ corteH.getAnchoCorte().multiply(corteH.getLargoCorte()));
        println("Tamanos H : "+corteH.getTamanosLS() +" X "+corteV.getTamanosAS() );
      //  println("Area Corte  : "+corteH.getAnchoCorteS() +" X "+corteH.getLargoCorteS()+" = "+ corteH.getAnchoCorteS().multiply(corteH.getLargoCorteS()));

        println("------------------------------");


        println("Total optimo: "+optimo.getTotal());
        println("Tamanos V : "+optimo.getTamanosL() +" X "+optimo.getTamanosA() );
        println("Area Corte  : "+optimo.getAnchoCorte() +" X "+optimo.getLargoCorte()+" = "+ optimo.getAnchoCorte().multiply(optimo.getLargoCorte()));
        println("Tamanos H : "+optimo.getTamanosLS() +" X "+optimo.getTamanosAS() );
        println("Area Corte  : "+optimo.getAnchoCorteS() +" X "+optimo.getLargoCorteS()+" = "+ optimo.getAnchoCorteS().multiply(optimo.getLargoCorteS()));

        println("------------------------------");

        BigDecimal areaPapel=anchoP.multiply(largoP);
        BigDecimal areaUsada=(optimo.getAnchoCorte().multiply(optimo.getLargoCorte())).add( optimo.getAnchoCorteS().multiply(optimo.getLargoCorteS()));
        BigDecimal porcUso= ((areaUsada.multiply(new BigDecimal(100)).divide(areaPapel , MathContext.DECIMAL128)).setScale(2, RoundingMode.FLOOR));
        BigDecimal porcSinUso=new BigDecimal(100).subtract(porcUso);
        println("Area Pliego: "+areaPapel);
        println("Area Usada: "+areaUsada);
        println("% Uso: "+porcUso);
        println("% Sin Usar: "+porcSinUso);

        def cortes =[ corteH, corteV, optimo];

        return cortes
    }

}

class CalculoCorte{

    private def anchoP;
    private def largoP;
    private def anchoC;
    private def largoC;
    private def tamanosA;
    private def tamanosL;
    private def tamanosT;
    private def anchoCorte;
    private def largoCorte;
    private def largoS;
    private def anchoS;
    private def tamanosAS;
    private def tamanosLS;
    private def tamanosTS;
    private def anchoCorteS;
    private def largoCorteS;
    private def total;

    def getAnchoS() {
        return anchoS;
    }

    def setAnchoS(def anchoS) {
        this.anchoS = anchoS;
    }

    def getAnchoP() {
        return anchoP;
    }

    def setAnchoP(def anchoP) {
        this.anchoP = anchoP;
    }

    def getLargoP() {
        return largoP;
    }

    def setLargoP(def largoP) {
        this.largoP = largoP;
    }

    def  getAnchoC() {
        return anchoC;
    }

    def setAnchoC(def anchoC) {
        this.anchoC = anchoC;
    }

    def getLargoC() {
        return largoC;
    }

    def setLargoC(def largoC) {
        this.largoC = largoC;
    }

    def getTamanosA() {
        return tamanosA;
    }

    def setTamanosA(def tamanosA) {
        this.tamanosA = tamanosA;
    }

    def getTamanosL() {
        return tamanosL;
    }

    def setTamanosL(BigDecimal tamanosL) {
        this.tamanosL = tamanosL;
    }

    def getTamanosT() {
        return tamanosT;
    }

    def setTamanosT(def tamanosT) {
        this.tamanosT = tamanosT;
    }

    def getAnchoCorte() {
        return anchoCorte;
    }

    def setAnchoCorte(def anchoCorte) {
        this.anchoCorte = anchoCorte;
    }

    def getLargoCorte() {
        return largoCorte;
    }

    def setLargoCorte(def largoCorte) {
        this.largoCorte = largoCorte;
    }

    def getLargoS() {
        return largoS;
    }

    def setLargoS(def largoS) {
        this.largoS = largoS;
    }

    def getTamanosAS() {
        return tamanosAS;
    }

    def setTamanosAS(def tamanosAS) {
        this.tamanosAS = tamanosAS;
    }

    def getTamanosLS() {
        return tamanosLS;
    }

    def setTamanosLS(def tamanosLS) {
        this.tamanosLS = tamanosLS;
    }

    def getTamanosTS() {
        return tamanosTS;
    }

    def setTamanosTS(def tamanosTS) {
        this.tamanosTS = tamanosTS;
    }

    def getAnchoCorteS() {
        return anchoCorteS;
    }

    def setAnchoCorteS(def anchoCorteS) {
        this.anchoCorteS = anchoCorteS;
    }

    def getLargoCorteS() {
        return largoCorteS;
    }

    def setLargoCorteS(def largoCorteS) {
        this.largoCorteS = largoCorteS;
    }

    def getTotal() {
        return total;
    }

    def setTotal(def total) {
        this.total = total;
    }

    def calcularCorte(def anchoP,def largoP,def anchoC,def largoC){

        this.anchoP=anchoP;
        this.largoP=largoP;
        this.anchoC=anchoC;
        this.largoC=largoC;

        tamanosA=(anchoP/anchoC).setScale(0, RoundingMode.FLOOR)
        tamanosL=(largoP/largoC).setScale(0, RoundingMode.FLOOR)
        tamanosT=tamanosA*tamanosL
        anchoCorte=anchoC*tamanosA
        largoCorte=largoC*tamanosL


        // Corte Sobrante

        largoS=largoP-largoCorte
        tamanosAS=(anchoP/largoC).setScale(0, RoundingMode.FLOOR)
        tamanosLS=(largoS/anchoC).setScale(0, RoundingMode.FLOOR)
        tamanosTS=tamanosAS*tamanosLS
        anchoCorteS=anchoC*tamanosAS
        total=tamanosT+tamanosTS
    }


    def calcularCorteOptimo(def anchoP,def largoP,def anchoC,def largoC,CalculoCorte optimo){

        calcularCorte(anchoP,largoP,anchoC,largoC);


        int count=tamanosA.intValue();

        while(count>1){

            tamanosA=tamanosA-1
            tamanosT=tamanosA*tamanosL
            anchoCorte=anchoC*tamanosA
            largoCorte=largoC*tamanosL


            // Corte Sobrante

            largoS=anchoP-anchoCorte
            anchoS=largoP
            tamanosAS=(largoS/largoC).setScale(0, RoundingMode.FLOOR);
            tamanosLS=(anchoS/anchoC).setScale(0, RoundingMode.FLOOR);
            tamanosTS=tamanosAS*tamanosLS
            anchoCorteS=largoC*tamanosAS
            largoCorteS=anchoC*tamanosLS
            total=tamanosT+tamanosTS


            if(optimo.getTotal().intValue()<total.intValue()){
                return this;
            }



            count=count-1;
        }

        return this;
    }

}
