# frozen_string_literal: true

module Avm
  module Applications
    class Base
      class AutoLocalSourcePath
        acts_as_instance_method
        common_constructor :application

        # @return [Pathname]
        def result
          application.scm.assert_main_at(fs_cache.path.to_pathname)
        end

        # @return [String]
        def fs_object_id
          application.id.to_s.parameterize
        end
      end
    end
  end
end
