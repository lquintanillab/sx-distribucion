<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Calculadora de Corte</title>
    <meta name="layout" content="corte"/>
    <![endif]-->
</head>
<body >


<div class="container">
    <div id="formulario">
        <div class="row row-centered flex-row row">
            <div class="col-sm-4 ext " style="backgroung-color=#E6E6E6">
                <div class="col-sm-10 col-sm-offset-1 col-centered">
                    <h2>MEDIDAS</h2>
                    <form class="form-horizontal" role="form" id="form_calc">
                        <h4>Tamaño de la Hoja</h4>
                        <div class="form-group">
                            <div class="col-sm-12 col-centered">
                                <div class="input-group calculadoraizq">
                                    <input class="form-control" id="papel_ancho" placeholder="Ancho" aria-describedby="basic-addon2" maxlength="5" tabindex="1" required>
                                    <span class="input-group-addon" id="basic-addon2">cm</span>
                                </div>
                            </div>
                        </div><!-- /.form-group -->

                        <div class="form-group">
                            <div class="col-sm-12 col-centered">
                                <div class="input-group calculadoraizq">
                                    <input class="form-control" id="papel_largo" placeholder="Largo" aria-describedby="basic-addon2" maxlength="5" tabindex="2" required>
                                    <span class="input-group-addon" id="basic-addon2">cm</span>
                                </div>
                            </div>
                        </div><!-- /.form-group -->

                        <h4>Tamaño del corte</h4>
                        <div class="form-group">
                            <div class="col-sm-12 col-centered">
                                <div class="input-group calculadoraizq">
                                    <input class="form-control" id="corte_ancho" placeholder="Ancho" aria-describedby="basic-addon3" maxlength="5" tabindex="3" required>
                                    <span class="input-group-addon"  id="basic-addon3">cm</span>
                                </div>
                            </div>
                        </div><!-- /.form-group -->

                        <div class="form-group">
                            <div class="col-sm-12 col-centered">
                                <div class="input-group calculadoraizq">
                                    <input class="form-control" id="corte_largo" placeholder="Largo" aria-describedby="basic-addon2" maxlength="5" tabindex="4" required>
                                    <span class="input-group-addon" id="basic-addon2">cm</span>
                                </div>
                            </div>
                        </div><!-- /.form-group -->

                        <h4>Cantidad</h4>

                        <div class="form-group">
                            <div class="col-sm-12 col-centered">
                                <div class="input-group calculadoraizq">
                                    <input class="form-control" id="cortes_deseados" placeholder="Número" tabindex="5">
                                    <span class="input-group-addon" id="basic-addon2">un</span>
                                </div>
                            </div>
                        </div><!-- /.form-group -->
                    </form>
                    <table class="table">
                        <tr>
                            <td class="text-center"><button type="submit" tabindex="6" class="btn btn-primary btn-circle" id="maximo"> <i class="material-icons">view_quilt</i></button><br>Optimo</td>
                            <td class="text-center"><button type="button" tabindex="7" class="btn btn-primary btn-circle" id="orientacion_h"><i class="material-icons">swap_horiz</i></button><br>Horizontal</td>
                        </tr>
                        <tr>
                            <td class="text-center"><button type="button" tabindex="8" class="btn btn-primary btn-circle" id="orientacion_v"><i class="material-icons">swap_vert</i></button><br>Vertical</td>
                            <td class="text-center"><button type="submit" tabindex="9" class="btn btn-info btn-circle" id="reset"><i class="material-icons">refresh</i></button><br>Reiniciar</td>
                        </tr>
                    </table>
                </div><!-- /col-sm-10 col-sm-offset-1 col-centered -->
            </div><!-- /col-sm-4 -->

            <div class="col-sm-4 medio " style="background-color:#D8D8D8">
                <div class="col-sm-12col-centered">
                    <h2>PAPEL</h2 >
                    <div id="dibujo">
                        <canvas id="micanvas">
                            Su navegador no soporta elementos Canvas
                        </canvas>
                    </div><!-- /dibujo -->
                </div><!-- /col-sm-10 col-sm-offset-1 col-centered -->
            </div><!-- /col-sm-4 -->

            <div class="col-sm-4 ext "  >
                <div class="col-sm-10 col-sm-offset-1 col-centered">
                    <h2 >RESULTADO</h2>
                    <table class="table table-bordered bg-info text-white">
                        <tr>
                            <td><label class="control-label" for="papel_ancho">Ejemplares por pliego</label></td>
                            <td><span class="label-result bg-info text-white" id="cortes_pliego">0</span></td>
                        </tr>
                        <tr>
                            <td><label class="control-label" for="numero_cortes_horizontal">Horizontales</label></td>
                            <td><span class="label-result" id="numero_cortes_horizontal">0</span></td>
                        </tr>
                        <tr>
                            <td><label class="control-label" for="numero_cortes_vertical">Verticales</label></td>
                            <td><span class="label-result" id="numero_cortes_vertical">0</span></td>
                        </tr>
                        <tr>
                            <td><label class="control-label" for="pliegos">Total pliegos</label></td>
                            <td><span class="label-result" id="pliegos">0</span></td>
                        </tr>
                        <tr>
                            <td><label class="control-label" for="numero_cortes">Total ejemplares</label></td>
                            <td><span class="label-result" id="numero_cortes">0</span></td>
                        </tr>
                    </table>
                    <table class="table table-bordered">
                        <tr>
                            <td class="bg-light"><span class="utilizada">% Utilizado</span></td>
                            <td class="bg-light"><span class="inutilizada">% Sin utilizar</span></td>
                        </tr>
                        <tr>
                            <td class="bg-info text-white"><span id="area_utilizada">0</span></td>
                            <td class="bg-secondary text-white"> <span id="area_inutilizada">0</span></td>
                        </tr>

                    </table>

                    <table class="table">
                        <tr>

                                <g:link class="btn btn-info btn-lg" controller="corte" action="pendientes" >
                                    <i class="material-icons">keyboard_return</i>
                                </g:link>
                                <br>Regresar
                            </td>

                        </tr>
                    </table>
                </div><!-- /col-sm-10 col-sm-offset-1 col-centered -->
            </div><!-- /col-sm-4 -->
        </div><!-- /row row-centered -->
    </div><!-- /.formulario -->
</div><!-- /.container -->

</body>
</html>