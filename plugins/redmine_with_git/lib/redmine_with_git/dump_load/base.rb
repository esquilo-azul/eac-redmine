# frozen_string_literal: true

module RedmineWithGit
  module DumpLoad
    class Base
      include ::ActionView::Helpers::NumberHelper

      def initialize(path)
        @path = path
        run
      end

      private

      attr_reader :path

      def resource_name
        self.class.name.demodulize.underscore
      end

      def env
        ::EacRubyUtils::Envs.local
      end

      def path_type
        env.command('file', '-b', path).execute!
      end
    end
  end
end
