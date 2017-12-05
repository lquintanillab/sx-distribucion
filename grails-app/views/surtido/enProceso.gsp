<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="layout" content="surtido"/>
    <title>Surtido en proceso</title>
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
            <g:if test="${flash.success}">
                <div class="alert alert-success">
                    <h4 class="text-center">${flash.success}</h4>
                </div>
            </g:if>
            <table id="grid" class="table table-striped table-bordered table-condensed ">
                <thead class="text-center">
                <tr >
                    <th class="text-center">Pedido</th>
                    <th>Cliente</th>
                    <th>Org</th>
                    <th>Entrega</th>
                    <th>Hora</th>
                    <th>Partidas</th>
                    <th>Cortes</th>
                    <th>Asignado</th>
                    <th  class="text-center">Status</th>
                    <th  class="text-center">Agregar Aux</th>
                    <th class="text-center">Cancelar</th>

                </tr>
                </thead>
                <tbody >
                <g:each in="${surtidoInstanceList}" var="row">
                    <tr class="text-center">
                        <td>

                            <g:link controller="surtidoAnalisis"action="analisis" id="${row.id}" class="btn btn-info btn-lg btn-block">
                                <g:formatNumber number="${row.documento}" format="####"/>
                            </g:link>

                        </td>
                        <td class="text-center">${fieldValue(bean:row,field:"nombre")}</td>
                        <td class="text-center">${fieldValue(bean:row,field:"entidad")}</td>
                        <td class="text-center">${fieldValue(bean:row,field:"entregaLocal")}</td>
                        <td class="text-center"><g:formatDate date="${row.fecha}" format="HH:mm (dd/MM)"/></td>
                        <td class="text-center"><g:formatNumber number="${row.prods}" format="####"/></td>
                        <td class="text-center"><g:formatNumber number="${row.prodsCorte}" format="####"/></td>
                        <td class="text-center">
                            ${fieldValue(bean:row,field:"asignado.username")}
                            <br>
                            <g:each in="${row?.auxiliares}" var="aux">
                                <span class="label label-primary">${aux.nombre}</span><br>
                                %{-- <ul class="text-center">${aux.nombre}</ul> --}%
                            </g:each>
                        </td>
                        <td class="${row.status=='EN SURTIDO'?'success':'danger'} text-center">
                            ${fieldValue(bean:row,field:"estado")}
                        </td>
                        <td class="text-center">
                            <a href="" data-toggle="modal" class="btn btn-default btn-lg btn-block"
                               data-target="#agregarAuxiliarModal"
                               data-whatever="${row.documento}"
                               data-surtido="${row.id}">
                                Agregar
                            </a>
                        </td>
                        <td class="text-center">

                            <g:if test="${ (row.prodsCorte && !row.corteInicio) || (!row.prodsCorte && row.status=='POR ENTREGAR') }">
                                <a href="#cancelarAsignacionModal" class="btn btn-default btn-lg btn-block"
                                   data-toggle="modal"
                                   data-target="#cancelarAsignacionModal"
                                   data-pedido="${row.documento}"
                                   data-surtido="${row.id}">
                                    <i class="material-icons">delete</i>
                                </a>
                            </g:if>
                            <g:else>

                            </g:else>
                        </td>
                    </tr>
                </g:each>
                </tbody>
            </table>

        </div>

    </div> <!-- end .row 2-->

    <g:render template="agregarAuxiliarDialog"/>
    <g:render template="cancelarAsignacion"/>


</div><!-- end .container-->

<script type="text/javascript">
			$(function(){
				//
				var count=0;

				setInterval(function(){

					var modal=$('#agregarAuxiliarModal');
					var modal2=$('#cancelarAsignacionModal');

					if (!modal.is(':visible') && !modal2.is(':visible')) {
	    				console.log('Actualizar consulta...'+count);
	    				window.location.reload();
					}
					count++;

				},10000);
			});
		</script>

</body>

