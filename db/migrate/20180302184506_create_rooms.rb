class CreateRooms < ActiveRecord::Migration[5.1]
  def change
    create_table :rooms do |t|
      t.string :dormid
      t.string :dormname
      t.string :roomid
      t.string :roomaccountid

      t.timestamps
    end
  end
end
