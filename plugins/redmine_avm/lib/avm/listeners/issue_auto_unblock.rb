# frozen_string_literal: true

module Avm
  module Listeners
    class IssueAutoUnblock
      include IssueDelete
      include IssueRelationDelete
      include IssueUpdate

      attr_reader :event

      def initialize(event)
        @event = event
      end

      def run
        return if check_conditions

        Rails.logger.debug("Unblock condition not found for #{@event}")
      end

      def check_conditions
        %w[issue_relation_deleted issue_deleted issue_updated].any? do |m|
          issues = send(m)
          next unless issues

          issues.each do |issue|
            Rails.logger.debug("#{m}: #{issue}")
            Avm::Issue::Unblock.new(issue).run
          end
          true
        end
      end
    end
  end
end
