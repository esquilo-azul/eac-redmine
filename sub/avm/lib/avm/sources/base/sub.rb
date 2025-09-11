# frozen_string_literal: true

module Avm
  module Sources
    class Base
      class Sub
        # !method initialize(source, sub_path)
        # @param source [Avm::Sources::Base]
        # @param sub_path [Pathname]
        common_constructor :source, :sub_path do
          self.sub_path = sub_path.to_pathname.cleanpath
        end

        # @return [Pathname]
        def absolute_path
          sub_path.expand_path(source.path)
        end

        require_sub __FILE__, require_mode: :kernel
      end
    end
  end
end
