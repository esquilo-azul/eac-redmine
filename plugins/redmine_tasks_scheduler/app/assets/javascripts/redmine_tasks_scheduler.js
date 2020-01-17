//= require 'tasks_scheduler'

_A = TasksScheduler.Alert;
_A.refresh = function () {
  $.ajax({
    url: _A.url,
    global: false,
    success: function (result) {
      var alert = $(_A.options.element_selector);
      var pattern = new RegExp('(^|\\s)' + _A.CSS_CLASSES_PREFIX + "\\S+", 'g');
      alert.removeClass(function (index, className) {
        return (className.match(pattern) || []).join(' ');
      });
      alert.addClass(_A.resultToCssClass(result));
    },
    complete: function (result) {
      _A.setNextRefresh();
    }
  });
};

TasksScheduler.Alert.init({
  element_selector: '.tasks-scheduler-alert'
});
