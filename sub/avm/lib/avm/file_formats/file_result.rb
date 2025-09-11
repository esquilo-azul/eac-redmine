# frozen_string_literal: true

require 'ostruct'

module Avm
  module FileFormats
    class FileResult
      common_constructor :file, :format, :changed
    end
  end
end
