class DropIssuesEsostiId < ActiveRecord::Migration
  def self.up
    remove_column :issues, :esosti_id
  end

  def self.down
    add_column :issues, :esosti_id, :integer
  end
end
