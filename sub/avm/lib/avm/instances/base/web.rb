# frozen_string_literal: true

require 'addressable'

module Avm
  module Instances
    class Base
      module Web
        common_concern do
          uri_components_entries_values 'web'
        end
      end
    end
  end
end
