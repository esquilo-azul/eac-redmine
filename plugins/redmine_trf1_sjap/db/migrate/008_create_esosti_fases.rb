class CreateEsostiFases < ActiveRecord::Migration
  def change
    create_table :esosti_fases do |t|
      t.string :rotulo
      t.integer :issue_status_id
      t.boolean :atribuir_autor
      t.timestamp :created_on
      t.timestamp :updated_on
    end
  end
end
