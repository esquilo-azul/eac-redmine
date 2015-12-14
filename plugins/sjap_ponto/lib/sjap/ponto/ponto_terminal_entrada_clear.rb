# encoding: UTF-8

module Sjap
  module Ponto
    class PontoTerminalEntradaClear
      def self.run
        ActiveRecord::Base.transaction do
          remove_ponto_entradas
          remove_ponto_terminal_entradas
        end
      end

      def self.remove_ponto_entradas
        count = PontoEntrada.delete_all <<EOT
id in (select exportado_id from ponto_terminal_entradas where exportado_type='PontoEntrada')
and id not in (select ponto_entrada_id from ponto_cancelamentos)
EOT
        Rails.logger.debug "Removido de ponto_entradas: #{count}"
      end

      def self.remove_ponto_terminal_entradas
        count = PontoTerminalEntrada.delete_all <<EOT
exportado_type='PontoEntrada' and
id not in (select id from ponto_entradas)
EOT
        Rails.logger.debug "Removido de ponto_terminal_entradas: #{count}"
      end
    end
  end
end
