class AddPasswordDigestToStuUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :stu_users, :password_digest, :string
  end
end
