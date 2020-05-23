# frozen_string_literal: true

Redmine::Plugin.post_register :redmine_with_git do
  # Source: https://github.com/esquilo-azul/redmine_nonproject_modules
  requires_redmine_plugin(:redmine_nonproject_modules, version_or_higher: '0.3.1')
  # Source: https://github.com/jbox-web/redmine_bootstrap_kit.git
  # Note: redmine_bootstrap_kit is a redmine_git_hosting's dependency.
  requires_redmine_plugin(:redmine_bootstrap_kit, version_or_higher: '0.2.5')
  # Source: https://github.com/jbox-web/redmine_git_hosting.git
  requires_redmine_plugin(:redmine_git_hosting, version_or_higher: '1.2.3')

  # Source: https://github.com/esquilo-azul/redmine_installer
  if ::Redmine::Plugin.registered_plugins.keys.include?(:redmine_installer)
    requires_redmine_plugin(:redmine_installer, version_or_higher: '0.10.0')
  end
end
