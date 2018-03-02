class CreateStuUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :stu_users do |t|
      t.string :idcard
      t.string :cardcode
      t.string :name
      t.string :sex
      t.string :birthday
      t.string :polite
      t.string :user_type
      t.string :phone1
      t.string :phone2
      t.string :qq
      t.string :wechatno
      t.string :usernc
      t.string :isld
      t.string :dormname
      t.string :areaid
      t.string :doorid
      t.integer :company_2_id
      t.string :company_2_name
      t.integer :department_id
      t.string :department
      t.string :hometell
      t.string :lx_jj
      t.string :phone_jj
      t.string :phone2_jj
      t.string :schno
      t.string :grade
      t.string :college
      t.string :major
      t.string :classes
      t.string :collegename
      t.string :majorname
      t.string :classesname
      t.string :region1
      t.string :region2
      t.string :region3
      t.string :region4
      t.string :regionname
      t.string :region1name
      t.string :region2name
      t.string :region3name
      t.string :region4name
      t.string :dormdetail
      t.string :familyname
      t.string :familytell
      t.string :fromschool
      t.string :headimg
      t.string :persign
      t.string :telsecrecy
      t.string :dormid
      t.string :homeaddress
      t.string 
      t.timestamps
    end
  end
end
