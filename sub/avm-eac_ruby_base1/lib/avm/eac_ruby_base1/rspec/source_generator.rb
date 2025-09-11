# frozen_string_literal: true

module Avm
  module EacRubyBase1
    module Rspec
      module SourceGenerator
        APPLICATION_STEREOTYPE = 'EacRubyBase1'
        DEFAULT_EAC_RUBY_GEM_SUPPORT_VERSION = '0.5.1'
        DEFAULT_EAC_RUBY_UTILS_VERSION = '0.104.0'

        # @return [Avm::EacRubyBase1::Sources::Base]
        def avm_eac_ruby_base1_source(options = {})
          options['eac-ruby-utils-version'] ||= DEFAULT_EAC_RUBY_UTILS_VERSION
          options['eac-ruby-gem-support-version'] ||= DEFAULT_EAC_RUBY_GEM_SUPPORT_VERSION
          avm_source(APPLICATION_STEREOTYPE, options)
        end
      end
    end
  end
end
