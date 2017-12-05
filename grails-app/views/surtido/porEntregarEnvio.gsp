<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="layout" content="surtido"/>
    <title>Surtido de pedidos</title>
</head>
<body>
<div>


    <div>
        <div>

            <g:if test="${flash.error}">
                <div class="alert alert-danger">
                    <h4 class="text-center">${flash.error}</h4>
                </div>
            </g:if>


            <table id="grid" class="table table-striped table-condensed col-md-12 ">
                <thead class="text-center">
                <tr >
                    <th>D</th>
                    <th class="text-center">Pedido</th>
                    <th class="text-center">Factura</th>
                    <th>T</th>
                    <th>Cliente</th>
                    <th>Entrega</th>
                    <th>Hora</th>
                    <th>Partidas</th>
                    <th>Cortes</th>
                    <th>Surtidor</th>
                    <th>Vendedor</th>
                    <th>
                        Entregar
                    </th>
                    <th>
                        Revisar
                    </th>


                </tr>
                </thead>
                <tbody>
                <g:each in="${surtidoInstanceList}" var="row">
                    <tr class="text-center">

                        <td>
                            <g:if test="${(row.depurado==null)  }">
                                <a href="" data-toggle="modal" class="btn btn-danger btn-lg btn-block"
                                   data-target="#depuracionDeSurtidoModal"
                                   data-whatever="${row.documento}"
                                   data-surtido="${row.id}"
                                   data-status="${row.status}">
                                    <i class="material-icons">power_settings_new</i>
                                </a>
                            </g:if>
                        </td>




                        <td class="">
                            <a href="" class="btn btn-success btn-lg btn-block">
                                <g:formatNumber number="${row.documento}" format="####"/>
                            </a>
                        </td>
                        <td class="">

                            <g:formatNumber number="${row.folioFac}" format="####"/>

                        </td>
                        <td>${fieldValue(bean:row,field:"tipoDeVenta")[0..0]}</td>
                        <td>${fieldValue(bean:row,field:"nombre")}</td>
                        <td>${fieldValue(bean:row,field:"entregaLocal")}</td>
                        <td><g:formatDate date="${row.fecha}" format="hh:mm (dd/MM)"/></td>
                        <td><g:formatNumber number="${row.prods}" format="####"/></td>
                        <td><g:formatNumber number="${row.prodsCorte}" format="####"/></td>
                        <td>${fieldValue(bean:row,field:"asignado.username")}</td>


                        <td>${fieldValue(bean:row,field:"userLastUpdate.username")}</td>

                        <td>
                            <g:if test="${row.entregado==null && (row.cierreSurtido==null) && (row.prodsCorte>row.prods) && (row.prodsCorte>0)  }">
                                <a href="" data-toggle="modal" class="btn btn-warning  btn-lg btn-block"
                                   data-target="#cierreDeSurtidoModal"
                                   data-whatever="${row.documento}"
                                   data-surtido="${row.id}"
                                   data-status="${row.status}">
                                    CIERRE
                                </a>
                            </g:if>
                            <g:elseif test="${row.entregado==null }">
                                <a href="" data-toggle="modal" class="btn btn-success  btn-lg btn-block"
                                   data-target="#entregaDeSurtidoModal"
                                   data-whatever="${row.documento}"
                                   data-surtido="${row.id}"
                                   data-status="${row.status}">
                                    ENTREGAR
                                </a>
                            </g:elseif>
                        </td>
                        <td>
                            <a href="" data-toggle="modal" class="btn btn-info btn-lg btn-block"
                               data-target="#revisionDeSurtidoModal"
                               data-whatever="${row.documento}"
                               data-surtido="${row.id}"
                               data-status="${row.status}">
                                REVISION
                            </a>

                        </td>



                    </tr>
                </g:each>
                </tbody>
            </table>
        </div>

    </div> <!-- end .row 2-->
    <g:render template="entregarSurtidoDialog"/>
    <g:render template="revizarSurtidoDialog"/>
    <g:render template="depurarSurtidoDialog"/>
    <g:render template="cerrarSurtidoDialog"/>

</div><!-- end .container-->

<script type="text/javascript">
			$(function(){
				//
				var count=0;

				setInterval(function(){

					var modal1=$('#entregaDeSurtidoModal');
					var modal2=$('#revisionDeSurtidoModal');
					var modal3=$('#depuracionDeSurtidoModal');

					if (!modal1.is(':visible') && !modal2.is(':visible')  && !modal3.is(':visible')) {
	    				console.log('Actualizar consulta...'+count);
	    				window.location.reload();
					}
					count++;

				},10000);
			});
		</script>


</body>

