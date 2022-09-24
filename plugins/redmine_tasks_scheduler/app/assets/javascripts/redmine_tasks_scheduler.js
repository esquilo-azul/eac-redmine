//= require 'tasks_scheduler'

function addGlobalFalseToAjaxDataFunction(obj, functionName) {
  var originalFunctionName = "original_" + functionName;
  obj[originalFunctionName] = obj[functionName];
  obj[functionName] = function() {
    var result = obj[originalFunctionName]();
    result.global = false;
    return result;
  };
}

addGlobalFalseToAjaxDataFunction(TasksScheduler.Alert, 'refreshAjaxData');
addGlobalFalseToAjaxDataFunction(TasksScheduler.Status, 'updateAjaxData');

TasksScheduler.Alert.init({
  element_selector: '.tasks-scheduler-alert'
});
