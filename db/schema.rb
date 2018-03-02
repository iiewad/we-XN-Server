# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180302184506) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "rooms", force: :cascade do |t|
    t.string "dormid"
    t.string "dormname"
    t.string "roomid"
    t.string "roomaccountid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stu_users", force: :cascade do |t|
    t.string "idcard"
    t.string "cardcode"
    t.string "name"
    t.string "sex"
    t.string "birthday"
    t.string "polite"
    t.string "user_type"
    t.string "phone1"
    t.string "phone2"
    t.string "qq"
    t.string "wechatno"
    t.string "usernc"
    t.string "isld"
    t.string "dormname"
    t.string "areaid"
    t.string "doorid"
    t.integer "company_2_id"
    t.string "company_2_name"
    t.integer "department_id"
    t.string "department"
    t.string "hometell"
    t.string "lx_jj"
    t.string "phone_jj"
    t.string "phone2_jj"
    t.string "schno"
    t.string "grade"
    t.string "college"
    t.string "major"
    t.string "classes"
    t.string "collegename"
    t.string "majorname"
    t.string "classesname"
    t.string "region1"
    t.string "region2"
    t.string "region3"
    t.string "region4"
    t.string "regionname"
    t.string "region1name"
    t.string "region2name"
    t.string "region3name"
    t.string "region4name"
    t.string "dormdetail"
    t.string "familyname"
    t.string "familytell"
    t.string "fromschool"
    t.string "headimg"
    t.string "persign"
    t.string "telsecrecy"
    t.string "dormid"
    t.string "homeaddress"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
