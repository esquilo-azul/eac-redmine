# frozen_string_literal: true

module Avm
  module Sources
    class Base
      module Subs
        CONFIGURATION_SUBS_EXCLUDE_PATHS_KEY = 'subs.exclude_path'
        CONFIGURATION_SUBS_INCLUDE_PATHS_KEY = 'subs.include_path'
        SUBS_EXCLUDE_PATHS_DEFAULT = [].freeze
        SUBS_INCLUDE_PATHS_DEFAULT = ['sub/*'].freeze

        # @return [Avm::Sources::Base, nil]
        def sub_for_path(path)
          subs.lazy.map { |sub| path.expand_path.child_of?(sub.path) ? sub : nil }.find(&:present?)
        end

        # @param sub_path [Pathname]
        # @return [Avm::Sources::Base::Sub]
        def sub(sub_path)
          ::Avm::Sources::Base::Sub.new(self, sub_path)
        end

        # @return [Enumerable<Avm::Sources::Base>]
        def subs
          subs_paths_to_search
            .map { |sub_path| ::Avm::Registry.sources.detect_optional(sub_path, parent: self) }
            .compact_blank
            .sort_by { |sub| [sub.path] }
        end

        def subs_paths_to_search
          subs_include_paths.flat_map do |subs_include_path|
            ::Pathname.glob(path.join(subs_include_path)).reject do |sub_path|
              subs_exclude_paths.any? do |subs_exclude_path|
                sub_path.fnmatch?(path.join(subs_exclude_path).to_path)
              end
            end
          end
        end

        %i[include exclude].each do |type|
          %i[path paths configured_paths default_paths].each do |method_suffix|
            obj_method_name = "subs_#{type}_path_obj"

            define_method "subs_#{type}_#{method_suffix}" do
              send(obj_method_name).send(method_suffix)
            end

            define_method "#{obj_method_name}_uncached" do
              ::Avm::Sources::Base::SubsPaths.new(
                self,
                self.class.const_get("CONFIGURATION_SUBS_#{type}_PATHS_KEY".upcase),
                self.class.const_get("SUBS_#{type}_PATHS_DEFAULT".upcase)
              )
            end

            private "#{obj_method_name}_uncached" # rubocop:disable Style/AccessModifierDeclarations
          end
        end
      end
    end
  end
end
