# frozen_string_literal: true

require 'test_helper'

module RedmineAvm
  module Listeners
    class IssueDependenciesSectionCheckTest < ActiveSupport::TestCase
      fixtures :enumerations, :issues, :issue_relations, :issue_statuses, :projects, :trackers,
               :users
      attr_reader :blocked, :blocking

      setup do
        @blocked = issues(:issues_009) # rubocop:disable Naming/VariableNumber
        @blocking = issues(:issues_010) # rubocop:disable Naming/VariableNumber
        @blocked.status = RedmineAvm::Settings.issue_status_blocked
        @blocked.save!
        @blocked.reload
        assert @blocked.relations_to.where(issue_from: @blocking).any?
        @status = RedmineAvm::Settings.issue_status_blocked
        assert_equal @status, @blocked.status
      end

      test 'dependencies ids with no dependencies section' do
        assert_status(<<~MESSAGE,
          There is not dependencies section.
        MESSAGE
                      RedmineAvm::Settings.issue_status_undefined)
      end

      test 'dependencies ids with empty dependencies section' do
        assert_status(<<~MESSAGE,
          There is a dependencies section.

          h3. Dependencies

          Here is the dependencies section
        MESSAGE
                      RedmineAvm::Settings.issue_status_undefined)
      end

      test 'dependencies ids without dependency writed' do
        assert_status(<<~MESSAGE,
          There is a dependencies section.

          h3. Dependencies

          #123 - dependency one
          dependency two: #456
          other dependencies: #234 #34
        MESSAGE
                      RedmineAvm::Settings.issue_status_undefined)
      end

      test 'dependencies ids with dependency writed' do
        assert_status(<<~MESSAGE,
          There is a dependencies section.

          h3. Dependencies

          #123 - dependency one
          dependency two: #456
          other dependencies: #10 #34
        MESSAGE
                      @status)
      end

      private

      def assert_status(description, status)
        @blocked.init_journal(users(:users_001), '') # rubocop:disable Naming/VariableNumber
        @blocked.description = description
        @blocked.save!
        @blocked.reload
        assert_equal status, @blocked.status
      end
    end
  end
end
