# frozen_string_literal: true

module EacRailsGemSupport
  module Rspec
    module Setup
      module RailsApp
        def builded_rails_app_path
          dir = app_root_path.join('spec', 'support', 'rails_app_append')
          return nil unless dir.directory?

          ::EacRailsGemSupport::Rspec::AppendableRailsApp.new(
            app_root_path, dir, builded_rails_app_path_target_dir
          ).target_dir
        end

        def builded_rails_app_path_target_dir
          root_tmp.join('rails_app')
        end

        def existing_rails_app_path
          [
            app_root_path,
            app_root_path.join('spec', 'support', 'rails_app')
          ].find { |app_path| app_path.join('config', 'environment.rb').file? }
        end

        # @return [Pathname]
        def rails_app_path_uncached
          existing_rails_app_path || builded_rails_app_path
        end

        def setup_rails_app # rubocop:disable Naming/PredicateMethod
          return false unless rails_app_path

          require rails_app_path.join('config', 'environment').to_path
          ::ActiveRecord::Migrator.migrations_paths = [rails_app_path.join('db', 'migrate')]
          raise('The Rails environment is running in production mode!') if Rails.env.production?

          require 'rspec/rails'
          require 'active_record/base'
          ::ActiveRecord::Migration.maintain_test_schema!
          true
        end

        def setup_rails_env
          ::Rails.env = ENV['RAILS_ENV'] ||= 'test'
        end
      end
    end
  end
end
