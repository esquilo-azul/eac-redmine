class CreatePontoCargaHorariaFuncionarios < ActiveRecord::Migration
  def change
    create_table :ponto_carga_horaria_funcionarios do |t|
      t.belongs_to :ponto_carga_horaria
      t.belongs_to :funcionario
      t.timestamps null: false
    end
  end
end
