# frozen_string_literal: true

module Avm
  module Scms
    module AutoCommit
      module Rules
        class Unique < ::Avm::Scms::AutoCommit::Rules::Base
          class WithFile < ::Avm::Scms::AutoCommit::Rules::Base::WithFile
            def commit_info
              return nil unless file.commits.one?

              new_commit_info.fixup(file.commits.first)
            end
          end
        end
      end
    end
  end
end
