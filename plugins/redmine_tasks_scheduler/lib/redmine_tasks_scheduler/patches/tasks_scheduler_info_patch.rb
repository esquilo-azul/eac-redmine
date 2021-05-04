# frozen_string_literal: true

# To-do: remove when fixed in gem "tasks_scheduler"
require 'tasks_scheduler/info'
const_name = 'TASKS_LIMIT_DEFAULT_VALUE'
::TasksScheduler::Info.send(:remove_const, const_name)
::TasksScheduler::Info.const_set(const_name, -1)
