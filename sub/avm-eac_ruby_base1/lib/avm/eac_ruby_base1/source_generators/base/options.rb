# frozen_string_literal: true

module Avm
  module EacRubyBase1
    module SourceGenerators
      class Base < ::Avm::SourceGenerators::Base
        module Options
          common_concern

          GEMFILE_LOCK_OPTION = :'gemfile-lock'

          OPTIONS = {
            GEMFILE_LOCK_OPTION => 'Run "bundle install" at the end'
          }.freeze

          module ClassMethods
            def option_list
              OPTIONS.merge(dependency_version_options).inject(super) { |a, e| a.option(*e) }
            end

            # @return [Hash<Symbol, String>]
            def dependency_version_options
              (common_dependency_gems + development_dependency_gems).sort.to_h do |gem_name|
                ["#{gem_name}_version".dasherize.to_sym, "Version for \"#{gem_name}\" gem."]
              end
            end
          end
        end
      end
    end
  end
end
