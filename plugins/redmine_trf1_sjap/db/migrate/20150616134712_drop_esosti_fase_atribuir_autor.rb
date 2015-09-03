class DropEsostiFaseAtribuirAutor < ActiveRecord::Migration
  def up
    remove_column :esosti_fases, :atribuir_autor
  end

  def down
    add_column :esosti_fases, :atribuir_autor, :boolean
  end
end
