class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :token
      t.references :room, null: false, foreign_key: true
      t.boolean :moderator

      t.timestamps
    end
    add_index :users, :token, unique: true
  end
end
