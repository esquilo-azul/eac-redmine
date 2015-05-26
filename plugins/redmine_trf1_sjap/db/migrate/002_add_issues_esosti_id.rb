class AddIssuesEsostiId < ActiveRecord::Migration
  def self.up
    add_column :issues, :esosti_id, :integer
  end

  def self.down
    remove_column :issues, :esosti_id
  end
end
