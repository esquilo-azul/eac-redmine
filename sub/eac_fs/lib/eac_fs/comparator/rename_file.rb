# frozen_string_literal: true

module EacFs
  class Comparator
    class RenameFile
      common_constructor :from, :to

      def apply(basename)
        basename == from ? to : basename
      end
    end
  end
end
