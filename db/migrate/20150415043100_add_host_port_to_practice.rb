class AddHostPortToPractice < ActiveRecord::Migration
  def change
    add_column :practices, :db_port, :integer
    add_column :practices, :db_host, :string
  end
end
