function EsostiAlerta() {
}

EsostiAlerta.ESOSTI_ALERTA_DATA_PATH = undefined;
EsostiAlerta.unidades_filter_options = null;
EsostiAlerta.__failedRequests = 0;

EsostiAlerta.start = function () {
  EsostiAlerta.from_unidades_filter_options();
  $.post(EsostiAlerta.ESOSTI_ALERTA_DATA_PATH, {
    matricula: $('#matricula').val(),
    senha: $('#senha').val(),
    banco: $('#banco').val(),
    unidades: EsostiAlerta.unidades_filter_options,
  }).success(function (data) {
    $('#resultContainer').html(data);
    EsostiAlerta.__failedRequests = 0;
    EsostiAlerta.__updateFailRequestDisplay();
    EsostiAlerta.on_new_data();
  }).always(function (data) {
    EsostiAlerta.__countdownTime = $('#intervalo').val();
    EsostiAlerta.__countdown();
  }).fail(function (data) {
    EsostiAlerta.__failedRequests++;
    EsostiAlerta.__updateFailRequestDisplay();
  });
};

EsostiAlerta.__countdown = function () {
  if (EsostiAlerta.__countdownTime <= 0) {
    $('#updateStatus').html("Atualizando...");
    EsostiAlerta.start();
  } else {
    $('#updateStatus').html("Atualização em " + EsostiAlerta.__countdownTime + " segundo(s)");
    EsostiAlerta.__countdownTime -= 1;
    setTimeout(EsostiAlerta.__countdown, 1000);
  }
};

EsostiAlerta.update = function () {
  EsostiAlerta.__countdownTime = 0;
};

EsostiAlerta.on_new_data = function () {
  EsostiAlerta.to_unidades_filter_options();
}

EsostiAlerta.to_unidades_filter_options = function () {
  EsostiAlerta.unidades_check_boxes().each(function (i) {
    $(this).attr('checked', EsostiAlerta.unidade_was_checked($(this).val()));
    $(this).change(function() {
      EsostiAlerta.unidades_filter_options[$(this).val()] = $(this).is(':checked') ? true : false;
      console.log("[" + $(this).val() + "]: " + $(this).is(':checked'));
    });
  });
}

EsostiAlerta.from_unidades_filter_options = function () {
  if (EsostiAlerta.unidades_check_boxes().length === 0) {
    return;
  }
  EsostiAlerta.unidades_filter_options = {};
  EsostiAlerta.unidades_check_boxes().each(function () {
    EsostiAlerta.unidades_filter_options[$(this).val()] = $(this).is(':checked') ? true : false;
  });
}

EsostiAlerta.unidades_check_boxes = function () {
  return $('.unidade_filter_option > input[type="checkbox"]');
}

EsostiAlerta.unidade_was_checked = function (id) {
  if (EsostiAlerta.unidades_filter_options) {
    return EsostiAlerta.unidades_filter_options[id] ? true : false;
  }
  else {
    return true
  }
}

EsostiAlerta.select_all_unidades = function (check) {
  EsostiAlerta.unidades_check_boxes().each(function () {
    this.checked = check;
  });
}

EsostiAlerta.__updateFailRequestDisplay = function() {
  var display = $('#failDisplay')  
  if (EsostiAlerta.__failedRequests >= 3) {
    display.html("Falha ocorrendo há " + EsostiAlerta.__failedRequests + "tentativa(s)");
    display.show();
  }
  else {
    display.hide();
  }
}
