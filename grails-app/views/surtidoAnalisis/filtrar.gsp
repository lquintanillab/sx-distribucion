<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="layout" content="application"/>
    <title>Surtido de pedidos</title>
    <asset:stylesheet src="datatables/datatables.css"/>
    <asset:javascript src="datatables/datatables.js"/>
    <asset:stylesheet src="jquery-ui-1.12.1/jquery-ui.css"/>
    <asset:javascript src="jquery-ui/autocomplete.js"/>

</head>
<body>
<div >

    <div>
        <div class="col-md-12">
            <div class="well">
                <h3 class="text-center">Surtidos registrados (${searchCommand.toPeriodo()})</h3>
                <g:link
                        action="dashboard"
                        class="btn btn-secondary  btn-lg btn-block seleccion">
               Administracion
                </g:link>
            </div>
        </div>
    </div>

    <div>

        <div class="col-md-4">
            <input type='text' id="filtro"
                   placeholder="Filtrar" class="form-control" autofocus="on">
        </div>

        <div class="col-md-8">
            <div class="btn-group">
                <button type="button" name="reportes"
                        class="btn btn-secondary " data-toggle="dropdown"
                        ><i class="material-icons">assignment</i>
                    Reportes <span class="caret"></span>
                </button>
                <ul class="dropdown-menu">
                    <li>
                        <a data-toggle="modal" data-target="#periodoCalendarioForm"> Reporte Uso</a>
                    </li>
                    <li>
                        <a data-toggle="modal" data-target="#corteUsoForm"> Reporte Uso en Corte</a>
                    </li>
                    <li>
                        <a data-toggle="modal" data-target="#empaqueUsoForm"> Reporte Uso en Empaque</a>
                    </li>
                </ul>
            </div>
            <div class="btn-group">
                <button type="button"
                        class="btn btn-secondary "
                        >
                    <a  data-toggle="modal"
                        data-target="#searchSurtidoDialog">
                        <i class="material-icons">search</i> Buscar
                    </a>
                </button>

            </div>
        </div>
    </div>


    <g:render template="calendarioPeriodoDialog"/>

    <g:render template="corteUsoReport"/>

    <g:render template="empaqueUsoReport"/>



</div><!-- end .container-->

<div>
    <div>
        <div class=" grid-panel">
            <table id="grid" class="table table-striped table-bordered ">
                <thead>
                <tr >
                    <th class="text-center">Tipo</th>
                    <th class="text-center">Forma</th>
                    <th>Entrega</th>
                    <th class="text-center">Cliente</th>
                    <th class="text-center">Pedido</th>
                    <th class="text-center">Venta</th>
                    <th class="text-center">Fecha Pedido</th>
                    <th class="text-center">Fecha Puesto</th>
                    <th class="text-center">Importado</th>
                    <th class="text-center">Fecha     </th>
                    <!--<th>Part</th>-->
                    <th>Surtió</th>
                    <th>Surtido</th>
                    <th>Entregado a Corte</th>
                    <th>C</th>
                    <th>Cortador</th>
                    <!--<th>Cortes</th>-->
                    <th>C Inicio</th>


                    <th>C Fin</th>

                    <!--<th>Entreg</th>-->
                    <th>Cierre</th>
                    <th>Entregado</th>


                    <th>Revisión</th>

                    <th>Status</th>


                </tr>
                </thead>
                <tbody>
                <g:each in="${surtidoInstanceList}" var="row">
                    <tr >
                        <td>${fieldValue(bean:row,field:"tipoDeVenta")}</td>
                        <td>${fieldValue(bean:row,field:"entidad")}</td>
                        <td>${fieldValue(bean:row,field:"entregaLocal")}</td>

                        <td>
                            <g:link action="analisis" id="${row.id}">
                                <abbr title="${row.nombre}">
                                    ${org.apache.commons.lang.StringUtils.substring(row.nombre,0,20)}
                                </abbr>
                            </g:link>

                        </td>
                        <td><g:formatNumber number="${row.documento}" format="####"/></td>

                        <td>${fieldValue(bean:row,field:"folioFac")}</td>

                        <td>${fieldValue(bean:row,field:"fecha")}</td>
                        <td>${fieldValue(bean:row,field:"fecha")}</td>

                        <td>${fieldValue(bean:row,field:"fecha")}</td>


                        <td>${fieldValue(bean:row,field:"fecha")}</td>



                        <td>${fieldValue(bean:row,field:"asignado.username")}</td>

                        <!--<td><g:formatDate date="${row.iniciado}" format="HH:MM"/></td>-->
                        <td>${fieldValue(bean:row,field:"iniciado")}</td>

                        <td>${fieldValue(bean:row,field:"asignacionCorte")}</td>

                        <td>
                            <g:if test="${row.cortes}"><i class="fa fa-scissors"></i></g:if>
                        </td>


                        <td>
                            <g:if test="${row.prodsCorte}">
                                ${row.cortes.first() .asignado.username}
                            </g:if>
                        </td>

                        <td>${fieldValue(bean:row,field:"corteInicio")}</td>

                        <!--<td>
                            <g:if test="${row.cortes}">
                                <g:formatDate date="${row.corteFin}" format="HH:MM (dd/MM)"/>
                            </g:if>
                            <g:else>
                                0
                            </g:else>
                        </td>-->
                        <td>${fieldValue(bean:row,field:"corteFin")}</td>



                        <!--<td>${fieldValue(bean:row,field:"entrego")}</td>-->

                        <!--<td><g:formatDate date="${row.entregado}" format="hh:MM (dd/MM)"/></td>-->

                        <td>${fieldValue(bean:row,field:"cierreSurtido")}</td>
                        <td>${fieldValue(bean:row,field:"entregado")}</td>

                        <!--<td><g:formatDate date="${row.revision}" format="hh:MM (dd/MM)"/></td>-->
                        <td>${fieldValue(bean:row,field:"revision")}</td>

                        <td>${fieldValue(bean:row,field:"estado")}</td>

                    </tr>
                </g:each>
                </tbody>
            </table>

        </div>

    </div> <!-- end .row 2-->

</div>

<g:render template="searchSurtidoDialog"/>

<script type="text/javascript">
		$(function(){



			$("table tbody").on('hover','tr',function(){
				$(this).toggleClass("info");
			});

			$(".table tbody tr").hover(function(){
				$(this).toggleClass("info");
			});

			$('#grid2').dataTable({
			    responsive: false,
			    "dom": '<"toolbar col-md-4">rt<"bottom"lp>',
			    "paging":   false,
			    "order": []
			      });

				$('#grid').dataTable( {
					"responsive": false,
			    	"paging":   false,
			    	"ordering": false,
			    	"info":     false,
			    	"dom": '<"toolbar col-md-4">rt<"bottom"lp>'
				} );



			$("#filtro").on('keyup',function(e){
			    var term=$(this).val();
			    $('#grid').DataTable().search(
			    $(this).val()
			    ).draw();
			});
		});




	</script>


</body>

