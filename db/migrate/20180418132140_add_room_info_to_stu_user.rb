class AddRoomInfoToStuUser < ActiveRecord::Migration[5.1]
  def change
    add_column :stu_users, :dorm, :string
  end
end
