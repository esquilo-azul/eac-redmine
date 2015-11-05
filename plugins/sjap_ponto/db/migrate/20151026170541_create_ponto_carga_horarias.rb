class CreatePontoCargaHorarias < ActiveRecord::Migration
  def change
    create_table :ponto_carga_horarias do |t|
      t.string :descricao
      t.date :data_inicial
      t.date :data_final
      t.integer :minutos_continuo
      t.integer :minutos_descontinuo
      t.belongs_to :autor, class_name: 'User'
      t.timestamps null: false
    end
  end
end
