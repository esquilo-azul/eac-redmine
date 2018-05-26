module RedmineWithGit
  module DumpLoad
    module Files
      private

      def files_path
        Rails.root.join('files')
      end
    end
  end
end
