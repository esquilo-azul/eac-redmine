class AddExportadoToPontoTerminalEntradas < ActiveRecord::Migration
  def change
    add_belongs_to :ponto_terminal_entradas, :exportado, polymorphic: true, index: false
    add_index :ponto_terminal_entradas, %w(exportado_id exportado_type), unique: true,
                                                                         name: 'index_ponto_terminal_entradas_on_exportado'
  end
end
