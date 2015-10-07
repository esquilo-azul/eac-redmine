# encoding: UTF-8

module Sjap
  module Ponto
    class PontoTerminalEntradaClear
      def self.run
        tpes = terminal_ponto_entradas
        total = tpes.count
        Rails.logger.debug "Total: #{tpes.count}"
        ActiveRecord::Base.transaction do
          count = 0
          tpes.each do |tpe|
            pe = tpe.exportado
            tpe.exportado = nil
            Trf1Sjap::ModelUtils.save_or_raise(tpe)
            Trf1Sjap::ModelUtils.destroy_or_raise(pe)
            count += 1
            Rails.logger.debug "Removidos: #{count}/#{total}"
          end
        end
      end

      def self.terminal_ponto_entradas
        PontoTerminalEntrada.where(exportado_type: 'PontoEntrada')
      end
    end
  end
end
