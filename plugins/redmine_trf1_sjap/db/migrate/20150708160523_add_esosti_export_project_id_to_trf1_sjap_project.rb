class AddEsostiExportProjectIdToTrf1SjapProject < ActiveRecord::Migration
  def change
    add_column :trf1_sjap_projects, :esosti_export_project_id, :integer, null: true
  end
end
