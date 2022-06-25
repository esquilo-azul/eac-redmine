# frozen_string_literal: true

require 'test_helper'
require 'aranha/parsers/source_target_fixtures'

module Avm
  module Issues
    class DependenciesSectionTest < ActiveSupport::TestCase
      fixtures :enumerations, :issues, :issue_relations, :issue_statuses, :projects, :trackers,
               :users

      test 'dependencies section' do
        ::Aranha::Parsers::SourceTargetFixtures.new(fixtures_dir).source_target_files do |s, t|
          td = YAML.load_file(t)
          issue = issue_with_description(File.read(s))

          assert_equal td[:dependencies_section],
                       issue.dependencies_section,
                       "Dependencies section\n#{s}"
          assert_equal td[:dependencies_section_dependencies].sort,
                       issue.dependencies_section_dependencies.sort,
                       "Dependencies section dependencies\n#{s}"
        end
      end

      private

      def fixtures_dir
        File.expand_path('dependencies_section_test_files', __dir__)
      end

      def issue_with_description(description)
        issue = issues(:issues_009)
        issue.init_journal(users(:users_001), '')
        issue.description = description
        issue.save!
        issue.reload
        blocking = issues(:issues_010)
        assert issue.relations_to.where(issue_from: blocking).any?
        issue
      end
    end
  end
end
