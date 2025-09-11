# frozen_string_literal: true

module Avm
  module EacRubyBase1
    module Launcher
      module Gem
        class Build
          enable_speaker

          def initialize(original_gem_root)
            @original_gem_root = original_gem_root
          end

          def output_file
            return nil unless @gem_root

            @gem_root.find_files_with_extension('.gem').first
          end

          def builded?
            output_file.present? && ::File.exist?(output_file)
          end

          def build
            return if builded?

            copy_gem_files
            build_gem
            check_gem_empty_size
            check_gem_version
          end

          def close
            ::FileUtils.remove_entry(@gem_root) if @gem_root && ::File.directory?(@gem_root)
            @gem_root = nil
          end

          private

          def copy_gem_files
            @gem_root = ::Avm::Launcher::Paths::Real.new(::Dir.mktmpdir)
            FileUtils.cp_r "#{@original_gem_root}/.", @gem_root
          end

          def build_gem
            info("Building gemspec #{gemspec_file}...")
            clear_gems
            Dir.chdir @gem_root do
              isolated_build_gem
            end
          end

          def isolated_build_gem
            on_clean_ruby do
              EacRubyUtils::Envs.local.command('gem', 'build', gemspec_file).execute!
            end
          end

          def check_gem_empty_size
            Dir.mktmpdir do |dir|
              Dir.chdir dir do
                EacRubyUtils::Envs.local.command('gem', 'unpack', gem).system
                gs = File.join(dir, File.basename(gem, '.gem'))
                if (Dir.entries(gs) - %w[. ..]).empty?
                  raise "\"#{dir}\" (Unpacked from #{gem}) has no source code"
                end
              end
            end
          end

          def clear_gems
            @gem_root.find_files_with_extension('.gem').each do |f|
              FileUtils.rm_rf(f)
            end
          end

          def gemspec_file
            @gem_root.find_file_with_extension('.gemspec')
          end

          def gem
            @gem_root.find_file_with_extension('.gem')
          end

          def check_gem_version
            spec = ::Avm::EacRubyBase1::Launcher::Gem::Specification.new(gemspec_file)
            return if ::File.basename(output_file, '.gem') == spec.full_name

            raise("Builded gem is not the same version of gemspec (#{spec}, #{output_file})")
          end

          def bundle_dependencies
            gemfile = @gem_root.subpath('Gemfile')
            return unless ::File.exist?(gemfile)

            Dir.chdir(@gem_root) do
              EacRubyUtils::Envs.local.command('bundle', 'install').execute!
            end
          end

          def on_clean_ruby(&block)
            on_clear_envvars('BUNDLE', 'RUBY', &block)
          end

          def on_clear_envvars(*start_with_vars)
            old_values = envvars_starting_with(start_with_vars)
            old_values.each_key { |k| ENV.delete(k) }
            yield
          ensure
            old_values&.each { |k, v| ENV[k] = v }
          end

          def envvars_starting_with(start_with_vars)
            ENV.select { |k, _v| start_with_vars.any? { |var| k.start_with?(var) } }
          end
        end
      end
    end
  end
end
