<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="layout" content="corte"/>
    <title>Cortes pendientes</title>
</head>
<body>
<div class="">
    <div>


        <div>

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
            <table class="table table-striped table-bordered table-condensed" id="grid">
                <thead>
                <tr>
                    <th>Pedido</th>
                    <th>T</th>
                    <th>Producto</th>
                    <th>Descripcion</th>

                    <th>Cortes</th>
                    <th>Instrucción</th>
                    <th>Asignado</th>
                    <th>S</th>
                    <th class="text-center">Surtido</th>
                    <th class="text-center">Corte</th>
                    <th class="text-center">Corte Global</th>
                </tr>
                </thead>
                <tbody>
                <g:each in="${corteInstanceList}" var="row">
                    <tr>
                        <td>
                            <a href="" data-toggle="modal" class="btn btn-light btn-lg btn-block">
                                <g:formatNumber number="${row.surtido.documento}" format="####"/>
                            </a>

                        </td>
                        <td>forma del surtido</td>
                        <td>${fieldValue(bean:row,field:"producto.clave")}</td>
                        <td>${fieldValue(bean:row,field:"producto.descripcion")}</td>


                        <td><g:formatNumber number="${row.surtido.prodsCorte}" format="####"/></td>
                        <td>${row.instruccionDeCorte?.instruccion}</td>
                        <td>
                            <g:if test="${row.asignado}">
                                ${fieldValue(bean:row,field:"asignado.username")}
                            </g:if>
                            <g:else>
                                Surtidor
                            </g:else>
                        </td>
                        <td>
                            <input class="seleccionMultiple" type="checkbox" name="pedidos" value="item1"
                                   data-corte="${row.id}" data-toggle="tooltip" title="Corte: ${row.id}">
                        </td>
                        <td class="text-center ${row.fin?'success':''}">
                            <g:if test="${!row.asignado}">

                                <a href="" data-toggle="modal"
                                   class="btn btn-info btn-lg btn-block"
                                   data-target="#corteModal"
                                   data-pedido="${row.surtido.documento}"
                                   data-descripcion="${row.instruccionDeCorte?.tipo}"
                                   data-corte="${row.id}"
                                   data-producto="${row.producto.clave}"
                                   data-cantidad="0"
                                   data-cortes="${row.surtido.prodsCorte}"
                                   data-surtidor="${row.surtido.asignado?.username}"
                                   data-instruccion="${row.instruccionDeCorte?.instruccion}"
                                   data-cortador="${row.asignado?.username}"
                                   data-empacador="${row.empacador?.username}"
                                   data-status="${row.statusCorte}">
                                    ${row.statusCorte}
                                </a>
                            </g:if>
                        </td>
                        <td class="text-center">


                            <g:if test="${row.statusCorte=='PENDIENTE'}">
                                <g:link
                                        action="iniciarCorte2" id="${row.id}"
                                        class="btn ${sec.loggedInUserInfo(field:"username")==row.asignado?'btn-success':'btn-info'}  btn-lg btn-block seleccion">
                                INICIAR
                                </g:link>
                            </g:if>
                            <g:elseif test="${row.statusCorte=='EN CORTE'}">

                                <g:if test="${sec.loggedInUserInfo(field:"username")==row.asignado.username}">
                                <g:link
                                        action="terminarCorte2" id="${row.id}"
                                        class="btn ${sec.loggedInUserInfo(field:"username")==row.asignado?'btn-success':'btn-secondary'}  btn-lg btn-block seleccion">
                                ${row.statusCorte=='PENDIENTE'?'INICIAR':row.statusCorte}
                                </g:link>
                                </g:if>
                                <g:else>
                                    ${sec.loggedInUserInfo(field:"username")}
                                </g:else>
                            </g:elseif>

                        </td>


                        <td class="text-center">
                            <g:if test="${row.asignado}">

                                <g:if test="${row.statusCorte=='PENDIENTE'}">
                                    <g:link
                                            action="iniciarCorteGlobal" id="${row.id}"
                                            class="btn btn-info btn-lg btn-block"
                                            class="btn ${sec.loggedInUserInfo(field:"username")==row.asignado?'btn-info btn-lg btn-block':'btn-secondary'}  btn-lg btn-block seleccion">
                                    INICIAR G
                                    </g:link>
                                </g:if>
                                <g:elseif test="${row.statusCorte=='EN CORTE'}">
                                    <g:if test="${sec.loggedInUserInfo(field:"username")==row.asignado.username}">
                                    <g:link
                                            action="terminarCorteGlobal" id="${row.id}"
                                            class="btn ${sec.loggedInUserInfo(field:"username")==row.asignado?'btn-info btn-lg btn-block':'btn-secondary'}  btn-lg btn-block seleccion">
                                    ${row.statusCorte=='PENDIENTE G'?'INICIAR G':row.statusCorte+' G'}
                                    </g:link>
                            </g:if>
                            <g:else>

                            </g:else>
                            </g:elseif>
                            </g:if>
                        </td>

                    </tr>
                </g:each>
                </tbody>
            </table>
        </div>

    </div> <!-- end .row 2-->

    <g:render template="corteDialog"/>
    %{-- <g:render template="empaqueDialog"/> --}%



</div><!-- end .container-->

<script type="text/javascript">
		$(function(){
			//
			var count=0;

			setInterval(function(){

				if (!$('#corteModal').is(':visible')) {
					//var loc=window.location
    				console.log('Actualizar consulta...'+count);
    				//console.log('Location: '+loc);
    				window.location.reload();
				}
				count++;

			},10000);

			$('.seleccion').on('click',function(e){
				var link=$(this);
				var href=link.attr("href");
				$('input:checked').each(function(){
				    var corte=$(this).data('corte');
				    if (href.indexOf('?') != -1) {
				        href=href+'&cortes='+corte;
				    }
				    else {
				        href=href+'?cortes='+corte;
				    }
				    link.attr("href", href);

				 });
				console.log('href: '+link.attr("href"));
				//e.preventDefault();
			});
		});
	</script>

</body>

