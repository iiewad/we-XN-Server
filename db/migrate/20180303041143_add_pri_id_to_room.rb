class AddPriIdToRoom < ActiveRecord::Migration[5.1]
  def change
    add_column :rooms, :pridormid, :string
    add_column :rooms, :address_type, :string
  end
end
