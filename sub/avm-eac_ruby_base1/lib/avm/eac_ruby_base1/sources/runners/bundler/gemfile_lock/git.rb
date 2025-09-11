# frozen_string_literal: true

module Avm
  module EacRubyBase1
    module Sources
      module Runners
        class Bundler
          class GemfileLock
            module Git
              private

              def git_continue
                infom "Adding \"#{gemfile_lock}\"..."
                git_repo.command('add', gemfile_lock).execute!
                if rebase_conflict?
                  git_continue_run('rebase')
                elsif cherry_conflict?
                  git_continue_run('cherry-pick')
                else
                  raise 'Unknown how to continue'
                end
              end

              def git_continue_run(command)
                infom "\"#{command}\" --continue..."
                cmd = git_repo.command(command, '--continue')
                        .envvar('GIT_EDITOR', 'true')
                return unless !cmd.system && !conflict?

                fatal_error "\"#{cmd}\" failed and there is no conflict"
              end

              def git_repo
                instance.scm.git_repo
              end

              def git_reset_checkout
                git_reset_gemfile_lock
                git_checkout_gemfile_lock
              end

              def git_checkout_gemfile_lock
                infom 'Checkouting...'
                git_repo.command('checkout', '--', gemfile_lock).system!
              end

              def git_reset_gemfile_lock
                infom 'Reseting...'
                git_repo.command('reset', gemfile_lock).system! if
                ::File.exist?(gemfile_lock)
              end
            end
          end
        end
      end
    end
  end
end
