Redmine::Plugin.post_register :redmine_nonproject_modules do
  # Source: https://github.com/esquilo-azul/redmine_plugins_helper
  requires_redmine_plugin(:redmine_plugins_helper, version_or_higher: '0.3.0')
  # Source: https://github.com/jbox-web/redmine_bootstrap_kit.git
  # Note: redmine_bootstrap_kit is a redmine_git_hosting's dependency.
  requires_redmine_plugin(:redmine_bootstrap_kit, version_or_higher: '0.2.5')
  # Source: https://github.com/jbox-web/redmine_git_hosting.git
  requires_redmine_plugin(:redmine_git_hosting, version_or_higher: '1.2.3')
end
