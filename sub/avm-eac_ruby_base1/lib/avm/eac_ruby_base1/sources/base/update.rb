# frozen_string_literal: true

module Avm
  module EacRubyBase1
    module Sources
      class Base < ::Avm::EacGenericBase0::Sources::Base
        module Update
          def on_sub_updated
            update_self_content
          end

          def update_self_content
            bundle_update.execute!
          rescue ::EacRubyUtils::Envs::ExecutionError
            raise ::Avm::Sources::UpdateError
          end
        end
      end
    end
  end
end
