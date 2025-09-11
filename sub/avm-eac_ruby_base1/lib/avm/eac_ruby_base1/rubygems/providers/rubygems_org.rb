# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'
require 'eac_envs/http/request'

module Avm
  module EacRubyBase1
    module Rubygems
      module Providers
        class RubygemsOrg < ::Avm::EacRubyBase1::Rubygems::Providers::Base
          DEFAULT_ROOT_HTTP_URL = 'https://rubygems.org'.to_uri

          # @param root_http_url [Pathname]
          def initialize(root_http_url = DEFAULT_ROOT_HTTP_URL)
            super
          end

          # @return [Enumerable<Hash>]
          def gem_versions(gem_name)
            ::EacEnvs::Http::Request.new
              .url(root_http_url + "/api/v1/versions/#{gem_name}.json")
              .response.body_data_or_raise
          rescue EacEnvs::Http::Response => e
            e.status == 404 ? [] : raise(e)
          end

          # @param gem_package_path [Pathname]
          # @return [Enumerable<String>]
          def push_gem_command_args(gem_package_path)
            command = ['gem', 'push', gem_package_path]
            unless ::Avm::Launcher::Context.current.publish_options[:confirm]
              command = %w[echo] + command + %w[(Dry-run)]
            end
            command
          end
        end
      end
    end
  end
end
