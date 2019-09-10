# frozen_string_literal: true

module RedmineWithGit
  module DumpLoad
    module Files
      private

      def files_path
        Rails.root.join('files').realpath.to_s
      end
    end
  end
end
