# frozen_string_literal: true

module Avm
  module Entries
    module Jobs
      module WithVariablesSource
        def variables_source
          ::Avm::Entries::Jobs::VariablesSource.new(self)
        end
      end
    end
  end
end
