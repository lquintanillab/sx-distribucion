<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="layout" content="surtido"/>
    <title>Sistema de distribución</title>

</head>
<body>



<div >
    <div >

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
                <th>S</th>
                <th>Org</th>
                <th>Entrega</th>
                <th class="text-center">Cliente</th>
                <th>Solicitó</th>
                <th>Clasificación</th>
                <th>Hora</th>
                <th>Partidas</th>
                <th>Cortes</th>
            </tr>
            </thead>
            <tbody >


            <g:each in="${surtidoInstanceList}" var="row">
                <tr class="text-center">

                    <td>
                        <a href="" data-toggle="modal" class="btn btn-info btn-lg btn-block"
                           data-target="#exampleModal"
                           data-whatever="${row.documento}"
                           data-surtido="${row.id}">
                            <g:formatNumber number="${row.documento}" format="####"/>
                        </a>
                    </td>
                    </td>
                    <td>
                        <input class="seleccionMultiple" type="checkbox" name="pedidos" value="item1"
                               data-surtido="${row.id}" data-toggle="tooltip" title="Surtido: ${row.id}">

                    </td>
                    <td class="text-center">${row.entidad}</td>
                    <g:if test="${row.entregaLocal}">
                        <td class="text-center">LOCAL</td>
                    </g:if>
                    <g:else>
                        <td class="text-center">ENVIO</td>
                    </g:else>
                    <td class ="text-center">${row.nombre}</td>
                    <td class ="text-center">${row.nombre}</td>
                    <td class ="text-center">
                        <a href=""
                           class="btn btn-info	 btn-lg btn-block"
                           data-toggle="modal"
                           data-target="#asignacionManualDialog"
                           data-pedido="${row.documento}"
                           data-surtido="${row.id}">
                            ${fieldValue(bean:row,field:"clasificacionVale")}
                        </a>
                    </td>
                    <td><g:formatDate date="${row.fecha}" format="HH:mm (dd/MM)"/></td>
                    <td class ="text-center">${row.prods}</td>
                    <td class ="text-center">${row.prodsCorte}</td>

                </tr>
            </g:each>
            </tbody>
        </table>

        <g:render template="atenderSurtidoDialog"/>
        <g:render template="asignacionManualDialog"/>

    </div>

    <script type="text/javascript">
			$(function(){
				//
				var count=0;

				setInterval(function(){

					var modal=$('#exampleModal');
					var modal2=$('#asignacionManualDialog');

					if (!modal.is(':visible') && !modal2.is(':visible')) {
	    				console.log('Actualizar consulta...'+count);
	    				window.location.reload();
					}
					count++;

				},10000);

			});

	</script>


</body>
</html>