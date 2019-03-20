Redmine::Plugin.post_register :redmine_avm do
  # Source: https://github.com/esquilo-azul/redmine_events_manager
  requires_redmine_plugin(:redmine_events_manager, version_or_higher: '0.3.1')
end
