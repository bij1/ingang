class CreateRooms < ActiveRecord::Migration[6.0]
  def change
    create_table :rooms do |t|
      t.string :name
      t.string :meeting
      t.string :attendee_pw
      t.string :moderator_pw

      t.timestamps
    end
    add_index :rooms, :meeting, unique: true
  end
end
