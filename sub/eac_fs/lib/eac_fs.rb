# frozen_string_literal: true

require 'eac_ruby_utils'
EacRubyUtils::RootModuleSetup.perform __FILE__

module EacFs
end

EacRubyUtils.require_sub(File.join(__dir__, 'eac_fs', 'patches'), recursive: true)
