class CreatePontoEntradas < ActiveRecord::Migration
  def change
    create_table :ponto_entradas do |t|
      t.datetime :data_hora
      t.belongs_to :funcionario
      t.belongs_to :terminal, class_name: 'PontoTerminal'
      t.belongs_to :autor, class_name: 'User'
      t.string :motivo

      t.timestamps null: false
    end
  end
end
