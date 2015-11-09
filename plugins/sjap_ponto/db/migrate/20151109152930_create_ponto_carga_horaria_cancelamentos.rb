class CreatePontoCargaHorariaCancelamentos < ActiveRecord::Migration
  def change
    create_table :ponto_carga_horaria_cancelamentos do |t|
      t.belongs_to :ponto_carga_horaria
      t.string :motivo
      t.belongs_to :autor, class_name: 'User'
      t.timestamps null: false
    end
  end
end
