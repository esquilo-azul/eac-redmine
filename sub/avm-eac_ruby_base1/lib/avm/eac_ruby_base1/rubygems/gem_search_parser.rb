# frozen_string_literal: true

module Avm
  module EacRubyBase1
    module Rubygems
      class GemSearchParser < ::Aranha::Parsers::Base
        GEM_STRUCT = ::Struct.new(:name, :versions)
        LINE_PARSER = /\A\s*(\S+)\s*\(([^)]+)\)\s*\z/.to_parser do |m|
          GEM_STRUCT.new(m[1], m[2].split(',').map(&:strip).reject(&:blank?))
        end

        # @return [Hash<String, Enumerable<String>]
        def data
          r = {}
          content.each_line do |line|
            parse_line(line).then do |line_parsed|
              next if line.blank?

              r[line_parsed.name] = line_parsed.versions
            end
          end
          r
        end

        # @param line [String]
        # @return [GEM_STRUCT]
        def parse_line(line)
          stripped_line = line.to_s.strip
          stripped_line.if_present(nil) { |v| LINE_PARSER.parse!(v) }
        end
      end
    end
  end
end
