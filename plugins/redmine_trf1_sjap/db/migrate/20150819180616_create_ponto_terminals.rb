class CreatePontoTerminals < ActiveRecord::Migration
  def change
    create_table :ponto_terminals do |t|
      t.string :descricao
      t.string :endereco
      t.string :tipo
      t.string :usuario
      t.string :senha

      t.timestamps null: false
    end
  end
end
