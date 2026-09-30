# frozen_string_literal: true

module EacRailsGemSupport
  module Rspec
    module Setup
      module Fixtures
        # @return [Enumerable<Pathname>]
        def fixture_paths
          [
            app_root_path.join('spec', 'fixtures'),
            app_root_path.join('test', 'fixtures')
          ].select(&:directory?)
        end

        # @return [void]
        def setup_fixtures
          rspec_config.use_transactional_fixtures = true
          rspec_config.fixture_paths ||= []
          rspec_config.fixture_paths += fixture_paths
        end
      end
    end
  end
end
