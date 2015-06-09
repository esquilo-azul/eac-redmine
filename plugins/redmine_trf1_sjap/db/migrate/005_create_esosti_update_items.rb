class CreateEsostiUpdateItems < ActiveRecord::Migration
  def change
    create_table :esosti_update_items do |t|
      t.integer :esosti_update_id
      t.string :nome
      t.text :valor
      t.timestamp :updated_on
      t.timestamp :created_on
    end
  end
end
