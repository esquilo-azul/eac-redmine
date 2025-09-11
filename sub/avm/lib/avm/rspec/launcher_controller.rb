# frozen_string_literal: true

require 'eac_config/node'

require 'fileutils'
require 'ruby-progressbar'
require 'tmpdir'

module Avm
  module Rspec
    class LauncherController
      attr_accessor :remotes_dir

      # @param application_id [String]
      # @param path [Pathname]
      # @return void
      def application_source_path(application_id, path)
        EacConfig::Node.context.current.entry("#{application_id}_dev.install.path").value =
          path.to_pathname.to_path
      end

      # @param settings_path [Pathname]
      # @param projects_root [Pathname]
      def context_set(settings_path, projects_root)
        Avm::Launcher::Context.current = Avm::Launcher::Context.new(
          settings_file: settings_path.to_pathname.to_path,
          cache_root: Dir.mktmpdir
        )
        self.projects_root = projects_root
      end

      # @return [Pathname]
      def default_settings_path
        templates_directory.join('settings.yml')
      end

      # @return [Pathname]
      def dummy_directory
        templates_directory.join('dummy')
      end

      # @param settings_path [Pathname]
      def temp_context(settings_path)
        context_set(settings_path, Dir.mktmpdir)
      end

      def init_remote(name)
        require 'avm/git/launcher/base'
        r = Avm::Git::Launcher::Base.new(File.join(remotes_dir, name))
        r.init_bare
        r
      end

      def init_git(subdir)
        require 'avm/git/launcher/base'
        r = Avm::Git::Launcher::Base.new(File.join(projects_root, subdir))
        r.git
        r.execute!('config', 'user.email', 'theuser@example.net')
        r.execute!('config', 'user.name', 'The User')
        r
      end

      # @return [Avm::Launcher::Context]
      def new_context
        Avm::Launcher::Context.new(
          settings_file: default_settings_path,
          cache_root: Dir.mktmpdir
        )
      end

      # @param path [String]
      def projects_root
        @projects_root ||= Dir.mktmpdir
      end

      # @param path [Pathname]
      def projects_root=(path)
        @projects_root = path.to_pathname.to_path
      end

      # @return [Pathname]
      def templates_directory
        '../../../template/avm/rspec/launcher_controller'.to_pathname.expand_path(__dir__)
      end

      def touch_commit(repos, subpath)
        require 'fileutils'
        FileUtils.mkdir_p(File.dirname(repos.subpath(subpath)))
        FileUtils.touch(repos.subpath(subpath))
        repos.execute!('add', repos.subpath(subpath))
        repos.execute!('commit', '-m', subpath)
      end
    end
  end
end
