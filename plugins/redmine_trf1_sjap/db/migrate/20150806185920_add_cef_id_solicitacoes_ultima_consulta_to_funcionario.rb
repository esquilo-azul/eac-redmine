class AddCefIdSolicitacoesUltimaConsultaToFuncionario < ActiveRecord::Migration
  def change
    add_column :funcionarios, :cef_id_solicitacoes_ultima_consulta, :datetime
  end
end
