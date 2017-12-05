<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="layout" content="empaque"/>
    <title>Cortes pendientes</title>
</head>
<body>
<div class="container-fluid">
    <div class="row">


        <div class="col-md-12">

            <g:if test="${flash.error}">
                <div class="alert alert-danger">
                    <h4 class="text-center">${flash.error}</h4>
                </div>
            </g:if>
            <g:if test="${flash.success}">
                <div class="alert alert-success">
                    <h4 class="text-center">${flash.success}</h4>
                </div>
            </g:if>
            <g:else>
                <div class="alert alert-info container-fluid">
                    <h3 class="text-center col-md-6">Operador: ${cortador?.nombre}</h3>
                    <g:link
                            data-toggle="modal"
                            class="btn 'btn-info' btn-lg btn-block seleccion col-md-2 text-white bg-info mt-2 mr-5"
                            data-target="#asignacionModal"
                            data-cortador="${cortador?.id}">
                    ASIGNARSE
                    </g:link>
                    <g:link
                            data-toggle="modal"
                            class="btn 'btn-info' btn-lg btn-block seleccion col-md-2 text-white bg-info mt-2"
                            data-target="#salirModal"
                            data-cortador="${cortador?.id}">
                        SALIR
                    </g:link>

                </div>
            </g:else>



            <table class="table table-striped table-bordered table-condensed" id="grid">
                <thead>
                <tr>
                    <th>Pedido</th>
                    <th>Producto</th>
                    <th>Descripcion</th>
                    <th>Fecha</th>
                    <th>Cortadores</th>
                    <th>Empacadores</th>
                    <th>S</th>
                    <th class="text-center">Empacado M</th>
                    <th class="text-center">Empacado</th>
                    <th class="text-center">Empacado G</th>
                </tr>
                </thead>
                <tbody>
                <g:each in="${corteInstanceList}" var="row">
                    <tr>
                        <td>
                            <a href="" data-toggle="modal" class="btn btn-default btn-lg btn-block">
                                <g:formatNumber number="${row.surtido.documento}" format="####"/>
                            </a>

                        </td>
                        <td>${fieldValue(bean:row,field:"producto.clave")}</td>
                        <td>${fieldValue(bean:row,field:"producto.descripcion")}</td>
                        <td><g:formatDate date="${row.surtido.fecha}" format="hh:mm (dd-MM)"/></td>
                        <td>
                            <a href="#agregarAuxiliarModal"
                               data-toggle="modal"
                               class=""
                               title="Agregar cortador auxiliar"
                               data-corte="${row.id}"
                               data-tipo="CORTADOR"
                               data-pedido="${row.surtido.documento}">
                                ${row.asignado.username}
                            </a>
                            <br>
                            <g:each in="${row.auxiliares}" var="aux">
                                <g:if test="${aux.tipo=='CORTADOR'}">
                                    <span class="label label-primary">${aux.auxiliarCorte.username}</span>
                                </g:if>
                            </g:each>


                        </td>
                        <td>
                            <a href="#agregarAuxiliarModal"
                               data-toggle="modal"
                               class=""
                               title="Agregar empacador auxiliar"
                               data-corte="${row.id}"
                               data-tipo="EMPACADOR"
                               data-pedido="${row.surtido.documento}">
                                ${row.empacador?.username}
                            </a>
                            <br>
                            <g:each in="${row.auxiliares}" var="aux">
                                <g:if test="${aux.tipo=='EMPACADOR'}">
                                    <span class="label label-primary">${aux.auxiliarCorte.username}</span><br>
                                </g:if>
                            </g:each>
                        </td>
                        <td>
                            <input class="seleccionMultiple" type="checkbox" name="cortes" value="item1"
                                   data-corte="${row.id}" data-toggle="tooltip" title="Corte: ${row.id}">
                        </td>

                        <td class="text-center">

                            <g:if test="${row.fin && !row.empacadoFin}">
                                <a href="" data-toggle="modal" class="btn btn-info btn-lg btn-block"
                                   data-target="#empaqueMesaModal"
                                   data-pedido="${row.surtido.documento}"
                                   data-descripcion="${row.producto.descripcion}"
                                   data-corte="${row.id}"
                                   data-producto="${row.producto.clave}"
                                   data-cantidad="0"
                                   data-cortes="${row.surtido.prodsCorte}"
                                   data-surtidor="${row.surtidor}"
                                   data-instruccion="${row.instruccionDeCorte?.instruccion}"
                                   data-cortador="${row.asignado.username}"
                                   data-empacador="${row.empacador}"
                                   data-statusEmpaque="${row.status}"
                                   data-empacadoInicio="${row.empacadoInicio}"
                                   data-empacadoFin="${row.empacadoFin}"
                                   data-status="${row.statusEmpaque}">
                                    ${row.status}
                                </a>
                            </g:if>
                            <g:else>
                                <g:formatDate date="${row.empacadoFin}" format="hh:mm (dd-MM)"/>
                                ${row.statusEmpaque}
                            </g:else>
                        </td>

                        <td class="text-center">
                            <g:if test="${row.fin && !row.empacadoFin}">
                                <a href="" data-toggle="modal" class="btn btn-info btn-lg btn-block"
                                   data-target="#empaqueModal"
                                   data-pedido="${row.surtido.documento}"
                                   data-descripcion="${row.producto.descripcion}"
                                   data-corte="${row.id}"
                                   data-producto="${row.producto.clave}"
                                   data-cantidad="0"
                                   data-cortes="${row.surtido.prodsCorte}"
                                   data-surtidor="${row.surtidor}"
                                   data-instruccion="${row.instruccionDeCorte?.instruccion}"
                                   data-cortador="${row.asignado.username}"
                                   data-empacador="${row.empacador}"
                                   data-statusEmpaque="${row.status}"
                                   data-empacadoInicio="${row.empacadoInicio}"
                                   data-empacadoFin="${row.empacadoFin}"
                                   data-status="${row.statusEmpaque}">
                                    ${row.status}
                                </a>
                            </g:if>
                            <g:else>
                                <g:formatDate date="${row.empacadoFin}" format="hh:mm (dd-MM)"/>
                                ${row.statusEmpaque}
                            </g:else>

                        </td>
                        <td class="text-center">
                            <g:if test="${row.fin && !row.empacadoFin}">
                                <a href="" data-toggle="modal" class="btn btn-success btn-lg btn-seleccion	"
                                   data-target="#empaqueGlobalModal"
                                   data-pedido="${row.surtido.documento}"
                                   data-descripcion="${row.producto.descripcion}"
                                   data-corte="${row.id}"
                                   data-producto="${row.producto.clave}"
                                   data-cantidad="0"
                                   data-cortes="${row.surtido.prodsCorte}"
                                   data-surtidor="${row.surtidor}"
                                   data-instruccion="${row.instruccionDeCorte?.instruccion}"
                                   data-cortador="${row.asignado}"
                                   data-empacador="${row.empacador}"
                                   data-statusEmpaque="${row.status}"
                                   data-empacadoInicio="${row.empacadoInicio}"
                                   data-empacadoFin="${row.empacadoFin}"
                                   data-status="${row.statusEmpaque}">
                                    ${row.status} G
                                </a>
                            </g:if>
                            <g:else>
                                <g:formatDate date="${row.empacadoFin}" format="hh:mm (dd-MM)"/>
                                ${row.statusEmpaque}
                            </g:else>

                        </td>


                    </tr>
                </g:each>
                </tbody>
            </table>
        </div>

    </div> <!-- end .row 2-->

    <g:render template="agregarAuxiliarDeCorteDialog"/>

    <g:render template="empaqueDialog"/>
    <g:render template="empaqueGlobalDialog"/>
    <g:render template="asignacionAMesa"/>
    <g:render template="salirDeMesa"/>
    <g:render template="terminarEmpacadoMesa"/>
</div><!-- end .container-->

<script type="text/javascript">
		$(function(){
			//
			var count=0;

			setInterval(function(){

				var empaqueModal=$('#empaqueModal');
				var auxiliarModal=$('#agregarAuxiliarModal');
				var empaqueGlobalModal=$('#empaqueGlobalModal');

				if (!empaqueModal.is(':visible') && !auxiliarModal.is(':visible') && !empaqueGlobalModal.is(':visible')) {
					//var loc=window.location
    				console.log('Actualizar consulta...'+count);
    				//console.log('Location: '+loc);
    				window.location.reload();
				}
				count++;

			},20000);
		});
	</script>

</body>

