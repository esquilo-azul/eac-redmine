# frozen_string_literal: true

module Avm
  module EacRubyBase1
    module Sources
      class Base < ::Avm::EacGenericBase0::Sources::Base
        module VersionBump
          def version_bump_do_changes(target_version)
            self.version = target_version
            bundle('install').chdir_root.execute!
          end
        end
      end
    end
  end
end
