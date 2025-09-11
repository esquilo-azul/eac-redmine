# frozen_string_literal: true

module Avm
  module EacRubyBase1
    module Rubygems
      module Providers
        class Base
          acts_as_abstract

          common_constructor :root_http_url do
            self.root_http_url = root_http_url.to_uri
            root_http_url.assert_argument(::Addressable::URI, 'root_http_url')
          end

          # @param gem_name [String]
          # @return [Enumerable<Hash>]
          def gem_versions(gem_name)
            raise_abstract __method__, gem_name
          end

          # @param gem_package_path [Pathname]
          # @return [Boolean]
          def push_gem(gem_package_path)
            command_args = push_gem_command_args(gem_package_path)
            command_args = %w[echo] + command_args + %w[(Dry-run)] unless
            ::Avm::Launcher::Context.current.publish_options[:confirm]
            ::EacRubyUtils::Ruby.on_clean_environment do
              EacRubyUtils::Envs.local.command(*command_args).system
            end
          end

          # @param gem_package_path [Pathname]
          # @return [Enumerable<String>]
          def push_gem_command_args(gem_package_path)
            raise_abstract __method__, gem_package_path
          end

          # @return [String]
          def to_s
            "#{self.class.name.demodulize}[#{root_http_url}]"
          end
        end
      end
    end
  end
end
