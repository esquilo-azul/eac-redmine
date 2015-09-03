class DropEsostiSolicitacaoEsostiNumero < ActiveRecord::Migration
  def change
    remove_column :esosti_solicitacaos, :esosti_numero, :string
  end
end
