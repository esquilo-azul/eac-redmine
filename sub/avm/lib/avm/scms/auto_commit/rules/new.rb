# frozen_string_literal: true

module Avm
  module Scms
    module AutoCommit
      module Rules
        class New < ::Avm::Scms::AutoCommit::Rules::Base
          class WithFile < ::Avm::Scms::AutoCommit::Rules::Base::WithFile
            def auto_commit_path
              ::Avm::Scms::AutoCommit::FileResourceName.new(file.scm, file.path)
            end

            def commit_info
              new_commit_info.message(auto_commit_path.commit_message)
            end
          end
        end
      end
    end
  end
end
