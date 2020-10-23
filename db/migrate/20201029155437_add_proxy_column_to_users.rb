class AddProxyColumnToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :proxy, :boolean
  end
end
