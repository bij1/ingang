class AddVoteColumnToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :vote, :boolean
  end
end
