module Heroku
  module Patches
    module RepositoryPatch
      extend ::ActiveSupport::Concern

      included do
        prepend Cloneable
      end

      def to_label
        "#{project ? project.identifier : '?'}:#{super}"
      end

      def to_s
        to_label
      end
    end
  end
end

::Repository.prepend(::Heroku::Patches::RepositoryPatch)
