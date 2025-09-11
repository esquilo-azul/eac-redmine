# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'
require 'eac_envs/http/request'

module Avm
  module EacRubyBase1
    module Rubygems
      module Providers
        class Nexus < ::Avm::EacRubyBase1::Rubygems::Providers::Base
          # @return [Enumerable<String>]
          def gem_versions(gem_name)
            search_result = ::Avm::EacRubyBase1::Rubygems::GemSearchParser.from_string(
              EacRubyUtils::Envs.local.command(
                'gem', 'search', '--quiet', '--exact', '--all',
                '--remote', '--clear-sources', '--source', root_http_url, gem_name
              ).execute!
            ).data
            (search_result.key?(gem_name) ? search_result.fetch(gem_name) : [])
              .map { |e| { 'number' => e } }
          end

          # @param gem_package_path [Pathname]
          # @return [Enumerable<String>]
          def push_gem_command_args(gem_package_path)
            ['gem', 'nexus', '--clear-repo', '--url', root_http_url, gem_package_path]
          end
        end
      end
    end
  end
end
