# frozen_string_literal: true

module Avm
  module Instances
    module Data
      class FilesUnit < ::Avm::Instances::Data::Unit
        EXTENSION = '.tar.gz'

        enable_listable
        lists.add_symbol :option, :sudo_user

        common_constructor :instance, :fs_path_subpath, :options, default: [{}],
                                                                  super_args: -> { [instance] } do
          self.fs_path_subpath = fs_path_subpath.to_pathname
          self.options = self.class.lists.option.hash_keys_validate!(options)
        end

        # @return [Pathname]
        def files_path
          fs_path_subpath
            .expand_path(instance.read_entry(::Avm::Instances::EntryKeys::INSTALL_PATH))
        end

        def dump_command
          instance_command('tar', '-czf', '-', '-C', files_path, '.')
        end

        def load_command
          instance_command('tar', '-xzf', '-', '-C', files_path)
        end

        def do_clear
          instance_command('mkdir', '-p', files_path).execute!
          instance_command('find', files_path, '-mindepth', 1, '-delete').execute!
        end

        # @return [Struct(:key, :subpath), nil]
        def installation_files_data
          return nil unless fs_path_subpath.relative?

          ::Struct.new(:key, :subpath).new(fs_path_subpath.basename.to_path, fs_path_subpath)
        end

        # @return [EacRubyUtils::Envs::Command]
        def instance_command(*args)
          args = ['sudo', '-Hu', sudo_user] + args if sudo_user.present?
          instance.host_env.command(*args).chdir('/')
        end

        # @return [String, nil]
        def sudo_user
          options[OPTION_SUDO_USER]
        end
      end
    end
  end
end
