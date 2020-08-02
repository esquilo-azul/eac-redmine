# frozen_string_literal: true

module RedmineAvm
  module Patches
    module IssuePatch
      def self.included(base)
        base.send(:include, InstanceMethods)
        base.send(:include, MotivationMethods)
      end

      module InstanceMethods
        def undefined?
          status == ::Avm::Settings.issue_status_undefined
        end

        def description_section(section_title)
          ['h\1\.', '----', '$'].each do |e|
            m = /h([0-9])\.\s*#{Regexp.escape(section_title)}(.+)#{e}/m
                .match(description)
            return m[2].strip + "\r\n" if m
          end
          nil
        end

        def dependencies
          children.all + relations_to.select do |r|
            r.relation_type == ::IssueRelation::TYPE_BLOCKS
          end.map(&:issue_from)
        end

        def r_dependencies
          rd = []
          rd << parent if parent
          rd + relations_from.select do |r|
            r.relation_type == ::IssueRelation::TYPE_BLOCKS
          end.map(&:issue_to)
        end

        def dependencies_section
          description_section(::Avm::Settings.dependencies_section_title)
        end

        def dependencies_section_dependencies
          s = dependencies_section
          return [] unless s

          s.scan(/\#([0-9]+)/).map { |x| x[0].to_i }
        end
      end

      module MotivationMethods
        def motivated?
          motivated_by_self? || motivated_by_relations?
        end

        def motivated_by_self?
          !undefined? && motivation_section.present?
        end

        def motivated_by_relations?
          !undefined? && r_dependencies.any?(&:motivated?)
        end

        def motivation_section
          description_section(::Avm::Settings.motivation_section_title)
        end
      end
    end
  end
end

unless ::Issue.included_modules.include? ::RedmineAvm::Patches::IssuePatch
  ::Issue.include ::RedmineAvm::Patches::IssuePatch
end
