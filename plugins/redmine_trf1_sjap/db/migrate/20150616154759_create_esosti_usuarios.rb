class CreateEsostiUsuarios < ActiveRecord::Migration
  def change
    create_table :esosti_usuarios do |t|
      t.string :matricula
      t.string :nome
      t.timestamp :created_on
      t.timestamp :updated_on
    end
  end
end
