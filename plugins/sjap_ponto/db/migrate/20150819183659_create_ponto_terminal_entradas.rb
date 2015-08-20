class CreatePontoTerminalEntradas < ActiveRecord::Migration
  def change
    create_table :ponto_terminal_entradas do |t|
      t.references :ponto_terminal, index: true, foreign_key: true
      t.string :tipo
      t.string :chave

      t.index [:ponto_terminal_id, :tipo, :chave], unique: true,
                                                   name: 'index_ponto_terminal_entradas_chave'
      t.timestamps null: false
    end
  end
end
