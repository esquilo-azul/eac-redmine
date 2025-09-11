# frozen_string_literal: true

module Avm
  module Entries
    module Jobs
      class VariablesSource
        require_sub __FILE__, require_dependency: true
        common_constructor :job
        delegate :instance, to: :job
      end
    end
  end
end
