function FuncionariosHelper(root_id, result_input_name) {
  this.root_id = root_id;
  this.result_input_name = result_input_name;
  var THIS = this;
  $(document).ready(function () {
    THIS.__form().submit(function (event) {
      try {
        THIS.__addValuesToForm();
      }
      catch (ex) {
        event.preventDefault();
        alert(ex);
      }
    });
    THIS.__root().find('input:radio[name="multi_funcionario_type"]').change(function () {
      THIS.update();
    });
    THIS.__root().find(".select_all").click(function () {
      THIS.__multiCheckBoxes().prop('checked', true);
      THIS.__root().find('.show_hide_control').each(function (i, c) {
        THIS.__showHideGroup(c, true);
      });
    });
    THIS.__root().find(".unselect_all").click(function () {
      THIS.__multiCheckBoxes().prop('checked', false);
    });
    THIS.__root().find(".show_hide_control").click(function () {
      THIS.__showHideGroupToogle(this);
    });
    THIS.update();
  });
}

FuncionariosHelper.prototype.update = function () {
  if (this.__type() == 'single') {
    this.__singleContainer().show();
    this.__multiContainer().hide();
  }
  else {
    this.__singleContainer().hide();
    this.__multiContainer().show();
  }
}

FuncionariosHelper.prototype.__type = function () {
  return this.__root().find('input[name="multi_funcionario_type"]:checked').val();
}

FuncionariosHelper.prototype.__root = function () {
  return $('#' + this.root_id);
}

FuncionariosHelper.prototype.__singleContainer = function () {
  return this.__root().find('.single_container');
}

FuncionariosHelper.prototype.__multiContainer = function () {
  return this.__root().find('.multi_container');
}

FuncionariosHelper.prototype.__form = function () {
  return this.__root().closest('form');
}

FuncionariosHelper.prototype.__addValuesToForm = function (form) {
  var ids = this.__type() == 'single' ? this.__singleIds() : this.__multiIds();
  var THIS = this;
  $.each(ids, function (i, v) {
    $(THIS.__form()).append($('<input />')
            .attr('type', 'hidden')
            .attr('name', THIS.result_input_name)
            .val(v));
  });
}

FuncionariosHelper.prototype.__multiCheckBoxes = function () {
  return this.__root().find('.funcionario > input[type="checkbox"]');
}

FuncionariosHelper.prototype.__singleIds = function () {
  return [this.__root().find('.single_container select').val()];
}

FuncionariosHelper.prototype.__multiIds = function () {
  var ids = [];
  this.__multiCheckBoxes().each(function () {
    if ($(this).is(':checked')) {
      var id = /\d+$/.exec($(this).attr('name'))
      if (id) {
        ids.push(id[0]);
      }
      else {
        throw 'Falhou ao tentar extrair o ID de "' + $(this).attr('name') + '"';
      }
    }
  });
  return ids;
}

FuncionariosHelper.prototype.__showHideContainer = function (control) {
  return $($(control).closest('.show_hide_parent').find('.show_hide_container'));
}

FuncionariosHelper.prototype.__showHideGroupToogle = function (control) {
  this.__showHideGroup(
          control,
          !this.__showHideContainer(control).is(":visible")
          );
}

FuncionariosHelper.prototype.__showHideGroup = function (control, show) {
  if (show) {
    $(control).text('[-]');
    this.__showHideContainer(control).css('display', 'table');
  }
  else {
    $(control).text('[+]');
    this.__showHideContainer(control).css('display', 'none');
  }
}