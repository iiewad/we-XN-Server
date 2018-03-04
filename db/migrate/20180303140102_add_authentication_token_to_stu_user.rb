class AddAuthenticationTokenToStuUser < ActiveRecord::Migration[5.1]
  def change
    add_column :stu_users, :wechat_open_id, :string
    add_column :stu_users, :authentication_token, :string
  end
end
