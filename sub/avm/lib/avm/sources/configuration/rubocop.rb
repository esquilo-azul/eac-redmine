# frozen_string_literal: true

module Avm
  module Sources
    class Configuration < ::EacConfig::OldConfigs
      module Rubocop
        RUBOCOP_COMMAND_KEY = 'ruby.rubocop.command'
        RUBOCOP_GEMFILE_KEY = 'ruby.rubocop.gemfile'

        def rubocop_command
          read_command(RUBOCOP_COMMAND_KEY)
        end

        def rubocop_gemfile
          gemfile_path = read_entry(RUBOCOP_GEMFILE_KEY)
          return nil if gemfile_path.blank?

          gemfile_path = gemfile_path.to_pathname.expand_path(storage_path.parent)
          return gemfile_path if gemfile_path.file?

          raise "Gemfile path \"#{gemfile_path}\" does not exist or is not a file"
        end
      end
    end
  end
end
