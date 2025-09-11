# frozen_string_literal: true

module Avm
  module Self
    class Instance < ::Avm::Instances::Base
      module EntryKeys
        DATA_DEFAULT_PATH = 'data.default_path'
        DOCKER_REGISTRY_NAME = 'docker.registry.name'
      end
    end
  end
end
