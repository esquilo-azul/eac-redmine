# frozen_string_literal: true

module EacFs
  module Rspec
    module Setup
      require_sub __FILE__

      # @return [self]
      def stub_eac_fs_contexts
        ::EacFs::Contexts::TYPES.each do |type|
          ::EacFs::Contexts.send(type).push(
            ::EacFs::StorageTree.new(::EacRubyUtils::Fs::Temp.directory)
          )
        end

        self
      end
    end
  end
end
