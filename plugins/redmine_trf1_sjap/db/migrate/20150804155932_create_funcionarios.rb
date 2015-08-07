class CreateFuncionarios < ActiveRecord::Migration
  def change
    create_table :funcionarios do |t|
      t.string :matricula
      t.string :nome
      t.string :cpf
      t.string :pis
      t.timestamps null: false
    end
  end
end
