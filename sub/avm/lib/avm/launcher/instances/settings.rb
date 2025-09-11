# frozen_string_literal: true

module Avm
  module Launcher
    module Instances
      class Settings
        DEFAULT_CURRENT_REVISION = 'origin/master'
        DEFAULT_PUBLISH_REMOTE = 'publish'

        common_constructor :data do
          self.data = (data.is_a?(Hash) ? data : {}).with_indifferent_access
        end

        def git_current_revision
          data[__method__] || DEFAULT_CURRENT_REVISION
        end

        def git_publish_remote
          data[__method__] || DEFAULT_PUBLISH_REMOTE
        end
      end
    end
  end
end
