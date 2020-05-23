# frozen_string_literal: true

$LOAD_PATH.unshift(::File.join(::File.dirname(__dir__)))
require 'eac_redmine_base0'

namespace :eac_redmine_base0 do
  namespace :plugins do
    desc 'Lists plugins maintained by E.A.C..'
    task list: :environment do
      ::EacRedmineBase0.maintained_plugins.each do |plugin|
        ::Rails.logger.info("Plugin: #{plugin.name} (ID: #{plugin.id})")
      end
    end

    desc 'Tests plugins maintained by E.A.C..'
    task test: :environment do
      ::EacRedmineBase0::PluginsTest.new.run
    end
  end

  task plugins: 'plugins:list'
end
