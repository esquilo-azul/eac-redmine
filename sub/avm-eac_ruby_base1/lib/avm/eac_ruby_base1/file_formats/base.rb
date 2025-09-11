# frozen_string_literal: true

module Avm
  module EacRubyBase1
    module FileFormats
      class Base < ::Avm::EacGenericBase0::FileFormats::Base
        require_sub __FILE__

        VALID_BASENAMES = %w[*.gemspec *.rake *.rb Gemfile Rakefile].freeze
        VALID_TYPES = ['x-ruby'].freeze

        def internal_apply(files)
          ::Avm::EacRubyBase1::Rubocop.new('.', ['-a', '--ignore-parent-exclusion'] + files).run
          super
        end
      end
    end
  end
end
