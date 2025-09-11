# frozen_string_literal: true

module Avm
  module EacRubyBase1
    class Rubocop
      module Gemfile
        def gemfile_rubocop_command
          return nil unless rubocop_gemfile?

          rubocop_command_by_gemfile_path(mygem.path)
        end

        def rubocop_command_by_gemfile_path(path)
          ::Avm::EacRubyBase1::Sources::Base.new(path).bundle('exec', 'rubocop').chdir_root
        end

        def rubocop_gemfile?
          return false if mygem.blank?

          mygem.bundle('install').execute!
          mygem.gemfile_lock_gem_version('rubocop').present?
        end

        private

        def mygem_uncached
          find_gem(::Pathname.new(base_path).expand_path)
        end

        def find_gem(path)
          r = ::Avm::EacRubyBase1::Sources::Base.new(path)
          return r if r.gemfile_path.exist?

          find_gem(path.dirname) unless path.root?
        end
      end
    end
  end
end
