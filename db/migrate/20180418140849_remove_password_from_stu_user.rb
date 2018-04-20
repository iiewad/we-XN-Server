class RemovePasswordFromStuUser < ActiveRecord::Migration[5.1]
  def change
    remove_column :stu_users, :password_digest
  end
end
