# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'
require 'eac_ruby_utils/patch'
require 'redmine_git_hosting/gitolite_hook'
require 'rbconfig'

module RedmineWithGit
  module Patches
    module RedmineGitHosting
      module GitoliteHookPatch
        def self.included(base)
          base.prepend(InstanceMethods)
        end

        module InstanceMethods
          SHEBANG_PATTERNS = [:ruby].map { |k| [k, /^\#!.+\s+#{::Regexp.quote(k)}\s*$/] }
                                    .to_h

          def hook_file_has_changed?
            on_content_replaced { super }
          end

          def install_hook_file
            on_content_replaced { super }
          end

          def on_content_replaced
            return yield unless replace_shebang?

            ::EacRubyUtils::Fs::Temp.on_file do |temp_path|
              temp_path.write(source_content_with_shebang_replaced)
              @temp_source_path = temp_path.to_path
              yield
            ensure
              @temp_source_path = nil
            end
          end

          # @return [Boolean]
          def replace_shebang?
            shebang_replacement.present?
          end

          # @return [String]
          def ruby_shebang
            bin = ::RbConfig::CONFIG['RUBY_INSTALL_NAME'] || ::RbConfig::CONFIG['ruby_install_name']
            bin += (::RbConfig::CONFIG['EXEEXT'] || ::RbConfig::CONFIG['exeext'] || '')
            ::File.join(::RbConfig::CONFIG['bindir'], bin)
          end

          # @return [Regexp]
          def shebang_from
            SHEBANG_PATTERNS.fetch(shebang_replacement)
          end

          # @return [Symbol, nil]
          def shebang_replacement
            SHEBANG_PATTERNS.each do |k, v|
              return k if v.match?(source_shebang)
            end

            nil
          end

          # @return [String]
          def shebang_to
            "\#\!#{send("#{shebang_replacement}_shebang")}\n"
          end

          # @return [String]
          def source_path
            @temp_source_path || super
          end

          # @return [String]
          def source_shebang
            ::File.open(source_path, &:readline).strip
          end

          # @return [String]
          def source_content_with_shebang_replaced
            ::File.read(source_path).gsub(shebang_from, shebang_to)
          end
        end
      end
    end
  end
end

::EacRubyUtils.patch(
  ::RedmineGitHosting::GitoliteHook,
  ::RedmineWithGit::Patches::RedmineGitHosting::GitoliteHookPatch
)
