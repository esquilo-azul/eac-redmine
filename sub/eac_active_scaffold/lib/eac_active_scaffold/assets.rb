# frozen_string_literal: true

module EacActiveScaffold
  module Assets
    OUTPUT_DIRECTORY_SUBPATH = 'tmp/active_scaffold/assets'

    class << self
      # @return [Pathname]
      def output_directory
        ::Rails.root.join(OUTPUT_DIRECTORY_SUBPATH).tap(&:mkpath)
      end
    end
  end
end
