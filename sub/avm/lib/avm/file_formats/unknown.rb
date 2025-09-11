# frozen_string_literal: true

module Avm
  module FileFormats
    class Unknown < ::Avm::FileFormats::Base
      # @params files [Enumerable<Pathname>]
      # @return [Enumerable<Avm::FileFormats::FileResult>]
      def apply(files)
        files.map do |file|
          ::Avm::FileFormats::FileResult.new(file, self.class, false)
        end
      end
    end
  end
end
