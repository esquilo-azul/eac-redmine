# frozen_string_literal: true

module Avm
  module Launcher
    class Project
      common_constructor :name, :instances do
        self.instances = instances.to_a
      end

      def to_s
        name
      end
    end
  end
end
