class CreateEsostiSolicitacaoPropriedades < ActiveRecord::Migration
  def change
    create_table :esosti_solicitacao_propriedades do |t|
      t.integer :esosti_solicitacao_id
      t.string :nome
      t.text :valor
      t.timestamp :updated_on
      t.timestamp :created_on
    end
  end
end
