# frozen_string_literal: true

module Avm
  module EacRubyBase1
    module Sources
      class GemfileLocal
        enable_simple_cache
        common_constructor :source

        def dependency_sub?(sub)
          sub.is_a?(::Avm::EacRubyBase1::Sources::Base) &&
            sub.gem_name != source.gem_name &&
            source.gemfile_lock_gem_version(sub.gem_name).present?
        end

        # @return [String]
        def target_content
          siblings.map(&:target_content).join
        end

        # @return [Pathname]
        def target_path
          source.path.join('Gemfile.local')
        end

        def on_unexisting_gemfile_local
          return yield unless target_path.exist?

          ::EacRubyUtils::Fs::Temp.on_file do |temp_file|
            ::FileUtils.cp(target_path, temp_file)
            begin
              ::FileUtils.rm_f(target_path)
              yield
            ensure
              ::FileUtils.cp(temp_file, target_path)
            end
          end
        end

        def run_bundle
          on_unexisting_gemfile_local do
            source.bundle.execute!
          rescue ::RuntimeError
            source.bundle('update').execute!
          end
        end

        # @return [void]
        def write_target_file
          target_path.write(target_content)
        end

        private

        def siblings_uncached
          source.parent.if_present([]) do |v|
            v.subs.select { |sub| dependency_sub?(sub) }.map do |sub|
              ::Avm::EacRubyBase1::Sources::GemfileLocal::Sibling.new(self, sub)
            end
          end
        end

        require_sub __FILE__
      end
    end
  end
end
