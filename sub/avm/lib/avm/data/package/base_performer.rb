# frozen_string_literal: true

module Avm
  module Data
    class Package
      class BasePerformer
        acts_as_abstract :result
        enable_speaker
        enable_listable
        lists.add_symbol :option, :excludes, :includes
        common_constructor :package, :options, default: [{}] do
          self.options = ::Avm::Data::Package::BasePerformer.lists.option
                           .hash_keys_validate!(options)
        end

        # @return [Set<Symbol>]
        def excludes
          ::Set.new((options[OPTION_EXCLUDES] || []).map(&:to_sym))
        end

        # @return [Set<Symbol>]
        def includes
          ::Set.new((options[OPTION_INCLUDES] || []).map(&:to_sym))
        end

        # @return [Hash<Symbol, Avm::Data::Unit]
        def selected_units
          r = package.units
          r = r.slice(*includes.to_a) if includes.any?
          r = r.except(*excludes.to_a) if excludes.any?
          r
        end
      end
    end
  end
end
