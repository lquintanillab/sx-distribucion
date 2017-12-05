<div class="modal fade" id="asignacionModal" tabindex="-1" role="dialog" aria-labelledby="asignacionModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="asignacionModalLabel">Asignacion a mesa de empaque</h4>
            </div>
            <g:form  name="asignarForm"   action="asignarseAMesaDeEmpaque" id="${cortador?.id}">

                <div class="modal-body">

                    <div class="form-group">
                        <label for="recipient-name" class="control-label">Operador: </label>
                        <input name="nip" type="password" class="form-control" id="recipient-name"
                               placeholder="Digite su NIP"
                               autocomplete="off">
                    </div>


                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Cancelar</button>

                    <g:submitButton class="btn btn-primary" name="aceptar" value="Asignar" />
                </div>
            </g:form>


        </div>
    </div>
</div>

<script type="text/javascript">
    $(document).ready(function(){
      $('#asignacionModal').on('show.bs.modal', function (event) {
        var button = $(event.relatedTarget); // Button that triggered the modal

        var modal = $(this);


      });

      $('body').on('shown.bs.modal', '.modal', function () {
          $('[id$=recipient-name]').focus();
      });

      $("form[name='asignarForm']").submit(function(e){
        var form=this;
      });

    });
  </script>