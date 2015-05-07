function EsostiAlerta() {
}

EsostiAlerta.ESOSTI_ALERTA_DATA_PATH = undefined;

EsostiAlerta.start = function() {
	$.post(EsostiAlerta.ESOSTI_ALERTA_DATA_PATH, {
		matricula : $('#matricula').val(),
		senha : $('#senha').val(),
		banco : $('#banco').val(),
	}).success(function(data) {
		$('#resultContainer').html(data);
	}).always(function(data) {
		EsostiAlerta.__countdownTime = 15;
	}).always(function(data) {
		EsostiAlerta.__countdownTime = $('#intervalo').val();
		EsostiAlerta.__countdown();
	});
};

EsostiAlerta.__countdown = function() {
	if (EsostiAlerta.__countdownTime <= 0) {
		$('#updateStatus').html("Atualizando...");
		EsostiAlerta.start();
	} else {
		$('#updateStatus').html("Atualização em " + EsostiAlerta.__countdownTime + " segundo(s)");
		EsostiAlerta.__countdownTime -= 1;
		setTimeout(EsostiAlerta.__countdown, 1000);
	}
}; 