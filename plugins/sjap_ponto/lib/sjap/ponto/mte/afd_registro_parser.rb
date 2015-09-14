module Sjap
  module Ponto
    module Mte
      # PORTARIA No 1.510, DE 21 DE AGOSTO DE 2009 do MTE, anexo I, Arquivo-Fonte de Dados – AFD
      class AfdRegistroParser
        class AfdWrongFormatException < Exception
        end

        class AfdRegistroTipo
          def initialize(campos)
            @campos = campos
          end

          def chars_length
            @chars_length ||= @campos.values.inject { |sum, c| sum + c }
          end

          def parse(line)
            r = {}
            offset = 0
            @campos.each do |k, v|
              r[k] = line[offset, v]
              offset += v
            end
            r
          end
        end

        TIPO_CABECALHO = '1'
        TIPO_ALTERACAO_EMPRESA = '2'
        TIPO_MARCACAO_PONTO = '3'
        TIPO_AJUSTE_RELOGIO = '4'
        TIPO_ALTERACAO_EMPREGADO = '5'
        TIPO_TRAILER = '9'

        TIPOS = {
          TIPO_CABECALHO => AfdRegistroTipo.new(
            nsr: 9,
            tipo: 1,
            tipo_pessoa: 1, # 1: CNPJ, 2: CPF
            cnpj_cpf: 14,
            cei: 12,
            razao_social: 150,
            rep_numero_fabricacao: 17,
            registros_data_inicial: 8,
            registros_data_final: 8,
            geracao_arquivo_data: 8,
            geracao_arquivo_hora: 4
          ),
          TIPO_ALTERACAO_EMPRESA => AfdRegistroTipo.new(
            nsr: 9,
            tipo: 1,
            gravacao_data: 8,
            gravacao_hora: 4,
            tipo_pessoa: 1, # 1: CNPJ, 2: CPF
            cnpj_cpf: 14,
            cei: 12,
            razao_social: 150,
            local_prestacao_servicos: 100
          ),
          TIPO_MARCACAO_PONTO => AfdRegistroTipo.new(
            nsr: 9,
            tipo: 1,
            data: 8,
            horario: 4,
            pis: 12
          ),
          TIPO_AJUSTE_RELOGIO => AfdRegistroTipo.new(
            nsr: 9,
            tipo: 1,
            antes_data: 8,
            antes_hora: 4,
            ajustado_data: 8,
            ajustado_hora: 4
          ),
          TIPO_ALTERACAO_EMPREGADO => AfdRegistroTipo.new(
            nsr: 9,
            tipo: 1,
            gravacao_data: 8,
            gravacao_hora: 4,
            operacao: 1, # I: inclusão, A: alteração, E: exclusão
            pis: 12,
            nome: 52
          ),
          TIPO_TRAILER => AfdRegistroTipo.new(
            nsr: 9,
            tipo_2_quantidade: 9,
            tipo_3_quantidade: 9,
            tipo_4_quantidade: 9,
            tipo_5_quantidade: 9,
            tipo: 1
          )
        }

        def initialize(registro)
          unless registro.is_a?(String)
            fail AfdWrongFormatException.new("Argumento \"registro\" deve ser uma string")
          end
          registro = registro.strip
          unless self.class.chars_range.member?(registro.length)
            fail AfdWrongFormatException.new(
              "Nº de caracteres do registro deve estar em #{self.class.chars_range}" \
                " (registro.length: #{registro.length}, " \
                "registro: \"#{registro}\")")
          end
          @registro = registro
        end

        def values
          return TIPOS[tipo].parse(@registro) if TIPOS[tipo]
          fail AfdWrongFormatException.new("Tipo de registro desconhecido (#{tipo} para #{@registro})")
        end

        def self.chars_range
          @@chars_range ||= (tipos_chars_length.min..tipos_chars_length.max)
        end

        def self.tipos_chars_length
          @@tipos_chars_length ||= TIPOS.values.map(&:chars_length)
        end

        def self.parse_line(line)
          new(line).values
        end

        private

        def nsr
          @registro[0, 9]
        end

        def tipo
          if nsr == '999999999' && @registro.length == 46 && @registro[45, 1] == TIPO_TRAILER
            return TIPO_TRAILER
          end
          @registro[9, 1]
        end
      end
    end
  end
end
