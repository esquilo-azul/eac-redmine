# encoding: UTF-8

module Sjap
  module Ponto
    module SuperFacil
      class PontoParser
        WITHOUT_SEPARATOR_PARTS = {
          begin: 10,
          day: 2,
          month: 2,
          year: 4,
          hours: 2,
          minutes: 2,
          pis: 12,
          extra: nil
        }

        WITH_SEPARATOR_PARTS = {
          begin: 10,
          day: 2,
          month: 2,
          year: 4,
          hours: 2,
          minutes: 2,
          separator: 1,
          pis: 12,
          extra: nil
        }

        def self.parse_line(line)
          if /^[0-9]{22}[^[0-9]]/.match(line)
            parse_line_with_parts(line, WITH_SEPARATOR_PARTS)
          else
            r = parse_line_with_parts(line, WITHOUT_SEPARATOR_PARTS)
            r[:separator] = ''
            r
          end
        end

        def self.parse_line_with_parts(line, parts)
          consumer = LineConsumer.new(line)
          result = {}
          parts.each do |k, v|
            result[k] = consumer.extract(v)
          end
          result
        end
      end

      class LineConsumer
        def initialize(line)
          @line = line
        end

        def extract(count)
          count = @line.length unless count
          result = @line[0, count]
          @line = @line[count, @line.length]
          result
        end
      end
    end
  end
end
