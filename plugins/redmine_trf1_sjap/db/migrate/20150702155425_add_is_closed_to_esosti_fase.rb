class AddIsClosedToEsostiFase < ActiveRecord::Migration
  def up    
    add_column :esosti_fases, :is_closed, :boolean, :default => false, :null => false
  end

  def down
    remove_column :esosti_fases, :is_closed
  end
end
