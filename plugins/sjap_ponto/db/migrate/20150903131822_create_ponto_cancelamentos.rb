class CreatePontoCancelamentos < ActiveRecord::Migration
  def change
    create_table :ponto_cancelamentos do |t|
      t.belongs_to :ponto_entrada
      t.belongs_to :autor, class_name: 'User'
      t.string :motivo

      t.timestamps null: false
    end
  end
end
