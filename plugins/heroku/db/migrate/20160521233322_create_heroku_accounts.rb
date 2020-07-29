class CreateHerokuAccounts < (
    Rails.version < '5.2' ? ActiveRecord::Migration : ActiveRecord::Migration[4.2]
  )
  def change
    create_table :heroku_accounts do |t|
      t.string :username
      t.string :password

      t.timestamps null: false
    end
  end
end
