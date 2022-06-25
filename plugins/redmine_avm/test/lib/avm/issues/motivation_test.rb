# frozen_string_literal: true

require 'test_helper'
require 'aranha/parsers/source_target_fixtures'

module Avm
  module Issues
    class MotivationTest < ActiveSupport::TestCase
      fixtures :enumerations, :issues, :issue_relations, :issue_statuses, :projects, :trackers,
               :users

      setup do
        ::IssueRelation.destroy_all
      end

      class << self
        def target_source_fixtures
          ::Aranha::Parsers::SourceTargetFixtures.new(fixtures_dir)
        end

        def fixtures_dir
          File.expand_path('motivation_test_files', __dir__)
        end
      end

      target_source_fixtures.source_target_files.each do |st|
        test "motivation #{::File.basename(st.source)}" do
          td = YAML.load_file(st.target)
          update_issues(YAML.load_file(st.source))

          %i[blocked blocked].each do |i|
            %i[motivated motivated_by_self motivated_by_relations].each do |m|
              expected = td[i][m]
              actual = send(i).send("#{m}?")
              assert_equal expected, actual, "#{i}/#{m}"
            end
          end
        end
      end

      test 'there are fixtures' do
        assert self.class.target_source_fixtures.source_target_files.count.positive?
      end

      private

      def update_issues(data)
        update_blocked(data[:description])
        update_blocker
        update_relation(data[:blocked_by])
      end

      def update_blocked(description)
        blocked.init_journal(users(:users_001), '')
        blocked.description = description
        blocked.status_id = issue_statuses(:issue_statuses_002).id
        blocked.save!
        blocked.reload
        assert_not blocked.undefined?, blocked.status
      end

      def update_blocker
        blocker.init_journal(users(:users_001), '')
        blocker.status_id = issue_statuses(:issue_statuses_002).id
        blocker.save!
        blocker.reload
        assert_not blocker.undefined?, blocker.status
      end

      def update_relation(blocked_by)
        relation = blocked.relations_to.where(issue_from: blocker)
        assert relation.empty?
        return unless blocked_by

        IssueRelation.create!(issue_to: blocked, issue_from: blocker,
                              type: IssueRelation::TYPE_BLOCKS)
        relation.destroy_all
        assert relation.any?
      end

      def blocked
        @blocked ||= issues(:issues_009)
      end

      def blocker
        @blocker ||= issues(:issues_010)
      end
    end
  end
end
