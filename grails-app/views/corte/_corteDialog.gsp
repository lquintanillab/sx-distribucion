<div class="modal fade" id="corteModal" tabindex="-1" role="dialog" aria-labelledby="corteModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">

            <div class="modal-header  bg-secondary">
                <h5 class="modal-title text-white" id="entregaModalLabel">Modal title</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <g:form  action="nodefinido" class="form-horizontal">
                <div class="modal-body container-fluid">
                    <g:hiddenField id="corteField" name="id"/>
                    <fieldset disabled>

                            <div class="form-group">
                                <label for="pedido" class="col-md-3 control-label  text-left">Pedido</label>
                                <div class="col-md-8">
                                    <input name="pedido" type="text" class="form-control" >
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="descripcion" class="col-md-3 control-label text-left">Descripcion</label>
                                <div class="col-md-8">
                                    <input name="descripcion" type="text" class="form-control" >
                                </div>
                            </div>

                        <div class="form-group">
                            <label for="cantidad" class="col-md-3 control-label text-left">Cantidad</label>
                            <div class="col-md-4">
                                <input name="cantidad" type="text" class="form-control" >
                            </div>
                            <label for="cortes" class="col-md-2 control-label">Cortes</label>
                            <div class="col-md-2">
                                <input name="cortes" type="text" class="form-control" >
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="instruccion" class="col-md-3 control-label text-left">Instrucción</label>
                            <div class="col-md-8">
                                <input name="instruccion" type="text" class="form-control" >
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="surtidor" class=" col-md-3 control-label text-left">Surtidor</label>
                            <div class="col-md-8">
                                <input name="surtidor" class="form-control"  disabled>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="cortador" class=" col-md-3 control-label text-left">Cortador</label>
                            <div class="col-md-8">
                                <input name="cortador" class="form-control" id="recipient-name" disabled>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="empacador" class=" col-md-3 control-label text-left">Empacador</label>
                            <div class="col-md-8">
                                <input name="empacador" class="form-control" id="recipient-name" disabled>
                            </div>
                        </div>
                    </fieldset>
                    <div class="form-group">
                        <label for="nip" class=" col-md-3 control-label text-left">Nip</label>
                        <div class="col-md-5">
                            <input name="nip" type="password" class="form-control" id="recipient-name" >
                        </div>
                    </div>


                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Cancelar</button>
                    <g:submitButton class="btn btn-info" name="aceptar" value="Entregar" />
                </div>
        </div>
            </g:form>
        </div>
    </div>
</div>


<script type="text/javascript">
	$(document).ready(function(){
		$('#corteModal').on('show.bs.modal', function (event) {
		  var button = $(event.relatedTarget); // Button that triggered the modal
		  var producto = button.data('producto');
		  var cantidad=button.data('cantidad');
		  var pedido=button.data('pedido');
		  var modal = $(this);
		  var cortador=button.data('cortador');

		  if(button.data('status')=='PENDIENTE'){
		  	modal.find('.modal-title').text('ENTREGANDO A  CORTE : ' + producto);
		  	modal.find('form').get(0).setAttribute('action', 'entregarACorte'); //this works
		  	console.log('Cortador: '+cortador);
		  	if(cortador!==null && cortador!==''){
		  		modal.find('.modal-title').text('INICIAR  CORTE : ' + producto);
		  		modal.find('form').get(0).setAttribute('action', 'iniciarCorte');
		  	}
		  }else{
		  	modal.find('.modal-title').text('CORTE TERMINADO DE: ' + producto);
		  	modal.find('form').get(0).setAttribute('action', 'terminarCorte'); //this works
		  }
		  modal.find("[name='descripcion']").val(button.data('descripcion'));
		  modal.find("[name='cantidad']").val(cantidad);
		  modal.find("[name='pedido']").val(pedido);
		  modal.find("[name='instruccion']").val(button.data('instruccion'));
		  modal.find("[name='cortes']").val(button.data('cortes'));
		  modal.find("[name='surtidor']").val(button.data('surtidor'));
		  modal.find("[name='cortador']").val(button.data('cortador'));
		  modal.find("[name='empacador']").val(button.data('empacador'));

		  modal.find('#corteField').val(button.data('corte'));
		});

	});
	$('body').on('shown.bs.modal', '.modal', function () {
			$('[id$=recipient-name]').focus();
	});

	$("form").submit(function(e){
	    var form=this;
	    $('input:checked').each(function(){
	        var corte=$(this).data('corte')
	        //console.log('Anexando corte: '+corte);
	        $('<input />').attr('type', 'hidden')
	          .attr('name', "cortes")
	        .attr('value', corte)
	        .appendTo(form);
	     });


	    //e.preventDefault(); //STOP default action
	});
</script>