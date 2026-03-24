# frozen_string_literal: true

module EacFs
  module Utils
    class << self
      def remove_empty_directories(root_path)
        return unless root_path.directory?

        root_path.children.each { |child_path| remove_empty_directories(child_path) }
        root_path.rmdir if root_path.empty?
      end
    end
  end
end
