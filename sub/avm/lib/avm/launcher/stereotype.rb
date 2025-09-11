# frozen_string_literal: true

require 'active_support/core_ext/string/inflections'
require 'colorized_string'

module Avm
  module Launcher
    module Stereotype
      class << self
        def included(base)
          base.extend(ClassMethods)
        end

        def git_stereotypes
          stereotypes.select { |c| c.name.demodulize.downcase.match('git') }
        end

        def nogit_stereotypes
          stereotypes - git_stereotypes
        end

        def stereotypes
          ::Avm::Registry.launcher_stereotypes.available
        end
      end

      module ClassMethods
        def label
          ::ColorizedString.new(stereotype_name).send(color)
        end

        def stereotype_name
          name.demodulize
        end

        {
          local_project_mixin: ::Module,
          publish: ::Class,
          update: ::Class,
          version_bump: ::Class,
          warp: ::Class
        }.each do |name, is_a|
          define_method "#{name}_#{is_a.name.underscore}" do
            sub_constant(name.to_s.camelcase, is_a)
          end
        end

        private

        def sub_constant(constant_name, is_a)
          return nil unless const_defined?(constant_name)

          constant = const_get(constant_name)
          unless is_a.if_present(true) { |v| constant.is_a?(v) }
            raise("#{constant} is not a #{is_a}")
          end

          constant
        end
      end
    end
  end
end
