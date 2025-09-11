# frozen_string_literal: true

module Avm
  module EacRubyBase1
    module Sources
      class BundleUpdate
        common_constructor :source
        delegate :bundle, to: :source

        def execute!
          bundle('update').execute! + bundle('install').execute!
        end

        def system!
          bundle('update').system!
          bundle('install').system!
        end
      end
    end
  end
end
