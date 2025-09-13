# frozen_string_literal: true

module RedmineAvm
  module Listeners
    class IssueAutoUndefine
      include IssueCreate
      include IssueUpdate
      include IssueRelationCreate

      attr_reader :event

      def initialize(event)
        @event = event
      end

      def run
        return if check_conditions

        Rails.logger.debug { "Undefine condition not found for #{@event}" }
      end

      def check_conditions
        %w[issue_created_undefined issue_updated_undefined
           issue_relation_created_undefined].any? do |m|
          issues = send(m)
          next unless issues

          issues.each do |issue|
            Rails.logger.debug { "#{m}: #{issue}" }
            RedmineAvm::Issue::Undefine.new(issue).run
          end
          true
        end
      end
    end
  end
end
