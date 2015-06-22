class CreateEsostiSolicitacaos < ActiveRecord::Migration
  def change
    create_table :esosti_solicitacaos do |t|
      t.boolean :closed
      t.integer :trf1_sjap_project_id
      t.integer :esosti_id
      t.string :esosti_numero
      t.integer :issue_id
      t.timestamp :updated_on
      t.timestamp :created_on
    end
  end
end
