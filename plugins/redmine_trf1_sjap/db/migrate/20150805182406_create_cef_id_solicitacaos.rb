class CreateCefIdSolicitacaos < ActiveRecord::Migration
  def change
    create_table :cef_id_solicitacaos do |t|
      t.string :nome
      t.string :perfil
      t.date :data
      t.string :protocolo
      t.string :situacao
      t.references :funcionario, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
