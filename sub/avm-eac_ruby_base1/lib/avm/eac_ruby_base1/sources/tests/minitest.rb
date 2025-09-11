# frozen_string_literal: true

module Avm
  module EacRubyBase1
    module Sources
      module Tests
        class Minitest < ::Avm::EacRubyBase1::Sources::Tests::Base
          def bundle_exec_args
            %w[rake test]
          end

          def dependency_gem
            'minitest'
          end

          def elegible?
            super && gem.rakefile_path.exist?
          end

          def test_directory
            'test'
          end
        end
      end
    end
  end
end
