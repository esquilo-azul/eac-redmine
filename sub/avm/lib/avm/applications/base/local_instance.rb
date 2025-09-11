# frozen_string_literal: true

module Avm
  module Applications
    class Base
      module LocalInstance
        LOCAL_INSTANCE_SUFFIX = 'dev'

        # @return [String]
        def local_instance_id
          ::Avm::Instances::Ids.build(id, local_instance_suffix)
        end

        # @return [String]
        def local_instance_suffix
          LOCAL_INSTANCE_SUFFIX
        end

        private

        # @return [Avm::Instances::Base]
        def local_instance_uncached
          instance(local_instance_suffix)
        end
      end
    end
  end
end
