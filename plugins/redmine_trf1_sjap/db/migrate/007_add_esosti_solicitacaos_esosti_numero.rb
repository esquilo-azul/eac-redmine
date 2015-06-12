class AddEsostiSolicitacaosEsostiNumero < ActiveRecord::Migration
  def self.up
    add_column :esosti_solicitacaos, :esosti_numero, :string
  end

  def self.down
    remove_column :esosti_solicitacaos, :esosti_numero
  end
end
