class AddAtendenteToEsostiSolicitacao < ActiveRecord::Migration
  def up
    add_column :esosti_solicitacaos, :atendente, :string, default: '', null: false
    add_column :esosti_solicitacaos, :atendente_anterior, :string, default: '', null: false
  end

  def down
    remove_column :esosti_solicitacaos, :atendente
    remove_column :esosti_solicitacaos, :atendente_anterior
  end
end
