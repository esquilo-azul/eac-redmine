# frozen_string_literal: true

require 'ostruct'

module Avm
  module FileFormats
    class Base
      enable_abstract_methods
      compare_by :class

      # @params files [Enumerable<Pathname>]
      # @return [Enumerable<Avm::FileFormats::FileResult>]
      def apply(_files)
        raise_abstract_method __method__
      end

      # @param path [Pathname]
      # @return [Avm::FileFormats::FileWith]
      def file_resource_name(path)
        path.to_pathname.to_path
      end

      def name
        self.class.name.demodulize
      end

      # @param file [Pathname]
      # @return [Boolean]
      def match?(_file)
        raise_abstract_method __method__
      end
    end
  end
end
