class AddLotacaoToFuncionario < ActiveRecord::Migration
  def change
    add_column :funcionarios, :lotacao, :string
  end
end
