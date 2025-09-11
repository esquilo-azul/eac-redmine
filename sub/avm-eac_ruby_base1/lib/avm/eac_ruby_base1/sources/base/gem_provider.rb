# frozen_string_literal: true

module Avm
  module EacRubyBase1
    module Sources
      class Base < ::Avm::EacGenericBase0::Sources::Base
        module GemProvider
          DEFAULT_GEM_PROVIDER_TYPE = 'rubygems_org'
          GEM_PROVIDER_CONFIG_ROOT_KEY = 'ruby.gem_provider'
          GEM_PROVIDER_CONFIG_TYPE_SUBKEY = 'type'
          GEM_PROVIDER_CONFIG_URL_SUBKEY = 'url'

          # @return [Avm::EacRubyBase1::Rubygems::Providers::Base]
          def default_gem_provider
            ::Avm::EacRubyBase1::Rubygems::Providers::RubygemsOrg.new
          end

          # @param subkey [String]
          # @return [String]
          def gem_provider_key(subkey)
            key = [GEM_PROVIDER_CONFIG_ROOT_KEY, subkey].join('.')
            r = nil
            [application, configuration].each do |provider|
              value = provider.entry(key).value
              if value.present?
                r = value
                break
              end
            end
            r
          end

          def gem_provider
            ::Avm::EacRubyBase1::Rubygems::Providers.const_get(
              (gem_provider_key(GEM_PROVIDER_CONFIG_TYPE_SUBKEY) || DEFAULT_GEM_PROVIDER_TYPE).to_s
                .camelize
            ).new(
              gem_provider_key(GEM_PROVIDER_CONFIG_URL_SUBKEY) ||
                ::Avm::EacRubyBase1::Rubygems::Providers::RubygemsOrg::DEFAULT_ROOT_HTTP_URL
            )
          end
        end
      end
    end
  end
end
