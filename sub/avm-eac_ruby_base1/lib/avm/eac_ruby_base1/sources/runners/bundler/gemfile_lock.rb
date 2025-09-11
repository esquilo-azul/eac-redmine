# frozen_string_literal: true

module Avm
  module EacRubyBase1
    module Sources
      module Runners
        class Bundler
          class GemfileLock
            require_sub __FILE__, include_modules: true
            runner_with :help do
              desc 'Manipulage a "Gemfile.lock" file.'
              bool_opt '-c', '--continue', 'Continue Git rebase/cherry-pick.'
              bool_opt '-i', '--install', 'Run "bundle install".'
              bool_opt '-u', '--update', 'Run "bundle update".'
              bool_opt '-r', '--recursive', 'Run until Git rebase/cherry-pick is finished.'
              bool_opt '-a', '--all', 'Same as "-cirud".'
              bool_opt '-d', '--delete', 'Delete Gemfile.lock'
            end

            def run
              loop do
                git_reset_checkout
                delete_gemfile_lock
                bundle_update
                bundle_install
                git_continue
                break if complete?
              end
            end

            private

            def complete?
              !option_or_all?(:recursive) || !conflict?
            end

            def delete_gemfile_lock
              ::FileUtils.rm_f(gemfile_lock)
            end

            def rebasing?
              git_repo.root_path.join('.git', 'rebase-merge').exist?
            end

            def bundle_install
              infom '"bundle install"...'
              bundle_run('install')
            end

            def bundle_update
              infom '"bundle update"...'
              bundle_run('update')
            end

            def gemfile_lock
              'Gemfile.lock'
            end

            def bundle_run(*args)
              instance.bundle(*args).system!
            end

            def conflict?
              rebase_conflict? || cherry_conflict?
            end

            def rebase_conflict?
              git_repo.root_path.join('.git', 'REBASE_HEAD').exist?
            end

            def cherry_conflict?
              git_repo.root_path.join('.git', 'CHERRY_PICK_HEAD').exist?
            end

            def option_or_all?(option)
              parsed[option] || parsed.all?
            end

            def instance
              runner_context.call(:subject)
            end
          end
        end
      end
    end
  end
end
