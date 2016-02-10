class RemoveIndexPontoTerminalExportadoUniqueness < ActiveRecord::Migration
  def up
    remove_pte_index
    add_pte_index(false)
  end

  def down
    remove_pte_index
    add_pte_index(true)
  end

  private

  def add_pte_index(unique)
    add_index :ponto_terminal_entradas, %w(exportado_id exportado_type), unique: unique,
                                                                         name: 'index_ponto_terminal_entradas_on_exportado'
  end

  def remove_pte_index
    remove_index :ponto_terminal_entradas, name: 'index_ponto_terminal_entradas_on_exportado'
  end
end
