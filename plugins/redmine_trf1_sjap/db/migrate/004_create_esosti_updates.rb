class CreateEsostiUpdates < ActiveRecord::Migration
  def change
    create_table :esosti_updates do |t|
      t.integer :esosti_solicitacao_id
      t.integer :index
      t.integer :journal_id
      t.timestamp :updated_on
      t.timestamp :created_on
    end
  end
end
