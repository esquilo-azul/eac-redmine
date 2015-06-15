class CreateTrf1SjapProjects < ActiveRecord::Migration
  def change
    create_table :trf1_sjap_projects do |t|
      t.integer :project_id
      t.string :eadmin_matricula
      t.string :eadmin_senha
      t.string :eadmin_banco
    end
  end
end
