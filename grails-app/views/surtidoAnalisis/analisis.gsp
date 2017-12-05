<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="layout" content="application"/>
    <title>Análisis de surtido ${surtidoInstance.documento}</title>
</head>
<body>
<div class="container">

    <div class="row">
        <br>
        <div class="alert alert-info col-sm-12">
            <a href="javascript:history.go(-1)">
                <h2>Cliente: ${surtidoInstance.nombre} Pedido: ${surtidoInstance.documento} </h2>
            </a>

        </div>
        <g:if test="${flash.message}">
            <div class="alert alert-info">
                <h4>${flash.message}</h4>
            </div>
        </g:if>
    </div>
    <!-- end .row -->

    <div  class="row">
        <div class="col-sm-6">
            <form>
                <div class="form-group row">
                    <label for="documento" class="col-sm-3 col-form-label">Docto</label>
                    <g:field class="form-control col-sm-8" name="documento" required="" value="${surtidoInstance?.documento}" readonly="true"> </g:field>
                </div>
                <div class="form-group row">
                    <label for="fecha" class="col-sm-3 col-form-label">Fecha</label>
                    <g:field class="form-control col-sm-8" name="fecha" required="" value="${surtidoInstance?.fecha}" readonly="true"> </g:field>
                </div>
                <div class="form-group row">
                    <label for="folioFac" class="col-sm-3 col-form-label">Factura</label>
                    <g:field class="form-control col-sm-8" name="folioFac" required="" value="${surtidoInstance?.folioFac}" readonly="true"> </g:field>
                </div>

                <div class="form-group row">
                    <label for="tipoDeVenta" class="col-sm-3 col-form-label">Tipo</label>
                    <g:field class="form-control col-sm-8" name="tipoDeVenta" required="" value="${surtidoInstance?.tipoDeVenta}" readonly="true"> </g:field>
                </div>
                <div class="form-group row">
                    <label for="cerro" class="col-sm-3 col-form-label">Cerro</label>
                    <g:field class="form-control col-sm-8 col-form-label" name="cerro" required="" value="${surtidoInstance?.cerro?.username}" readonly="true"> </g:field>
                </div>

            </form>
        </div>
        <div class="col-sm-6">
            <form>

                <div class="form-group row">
                    <label for="asignado" class="col-sm-3 col-form-label">Asignado</label>
                    <g:field class="form-control col-sm-8 col-form-label" name="asignado" required="" value="${surtidoInstance?.asignado.username}" readonly="true"> </g:field>
                </div>

                <div class="form-group row">
                    <label for="iniciado" class="col-sm-3 col-form-label">Iniciado</label>
                    <g:field class="form-control col-sm-8 col-form-label" name="iniciado" required="" value="${surtidoInstance?.iniciado}" readonly="true"> </g:field>
                </div>
                <div class="form-group row">
                    <label for="entrego" class="col-sm-3 col-form-label">Entrego</label>
                    <g:field class="form-control col-sm-8 col-form-label" name="entrego" required="" value="${surtidoInstance?.entrego?.username}" readonly="true"> </g:field>
                </div>
                <div class="form-group row">
                    <label for="entregado" class="col-sm-3 col-form-label">Entregado</label>
                    <g:field class="form-control col-sm-8 col-form-label" name="entregado" required="" value="${surtidoInstance?.entregado}" readonly="true"> </g:field>
                </div>
                <div class="form-group row">
                    <label for="revisionUsuario" class="col-sm-3 col-form-label">Reviso</label>
                    <g:field class="form-control col-sm-8 col-form-label" name="revisionUsuario" required="" value="${surtidoInstance?.revisionUsuario?.username}" readonly="true"> </g:field>
                </div>
            </form>
        </div>

    </div>


    <div class="row grid-panel">
        <div class="col-sm-12">
            <div class="panel panel-primary">
                <div class="panel-heading">
                    Partidas
                </div>
                <table class="table table-striped table-bordered table-condensed ">
                    <thead>
                    <tr>
                        <th>Producto</th>
                        <th>Descripción</th>
                        <th>Cantidad</th>
                    </tr>
                    </thead>
                    <tbody>
                    <g:each in="${surtidoInstance.partidas}" var="row">
                        <tr>
                            <td>${fieldValue(bean:row,field:"producto")}</td>
                            <td>${fieldValue(bean:row,field:"descripcion")}</td>
                            <td>${fieldValue(bean:row,field:"cantidad")}</td>
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <g:if test="${cortes}">
        <div class="row grid-panel">
            <div class="col-sm-12">
                <div class="panel panel-primary">
                    <div class="panel-heading">
                        Cortes
                    </div>
                    <table class="table table-striped table-bordered table-condensed ">
                        <thead>
                        <tr>
                            <th>Producto</th>
                            <th>Descripción</th>
                            <th>Instrucción</th>
                            <th>Cant</th>
                            <th>Cortador</th>
                            <th>Empacador</th>
                        </tr>
                        </thead>
                        <tbody>
                        <g:each in="${cortes}" var="row">
                            <tr>
                                <td>${fieldValue(bean:row,field:"producto")}</td>
                                <td>${fieldValue(bean:row,field:"descripcion")}</td>
                                <td>${fieldValue(bean:row,field:"instruccion")}</td>
                                <td>${formatNumber(number:row.cantidad,format:'#,####.###')}</td>
                                <td>${fieldValue(bean:row,field:"asignado")}</td>
                                <td>${fieldValue(bean:row,field:"empacador")}</td>

                            </tr>
                        </g:each>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </g:if>
</div><!-- end .container-->


</body>

