# frozen_string_literal: true

module Avm
  module Sources
    class Base
      class Sub
        class Remove
          acts_as_instance_method

          # !method initialize(sub)
          # @param sub [Avm::Sources::Base::Sub]
          common_constructor :sub
          delegate :source, to: :sub

          # @return [void]
          def result
            source.scm.commit_if_change(commit_message) { do_changes }
          end

          private

          # @return [String]
          def commit_message
            sub.i18n_translate(:remove_commit_message, sub_path: sub.sub_path)
          end

          # @return [void]
          def do_changes
            ::FileUtils.rm_rf(sub.absolute_path)
            source.on_sub_updated
          end
        end
      end
    end
  end
end
