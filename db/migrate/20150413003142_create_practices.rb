class CreatePractices < ActiveRecord::Migration
  def change
    create_table :practices do |t|
      t.integer :user_id
      t.string  :name
      t.string  :db_username
      t.string  :db_password
      t.string  :secret_key

      t.timestamps null: false
    end
  end
end
