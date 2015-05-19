class AddIssuesEsostiNumero < ActiveRecord::Migration
  def self.up
    add_column :issues, :esosti_numero, :string
  end

  def self.down
    remove_column :issues, :esosti_numero
  end
end
