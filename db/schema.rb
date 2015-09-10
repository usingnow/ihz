# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150910145212) do

  create_table "free_insurances", force: :cascade do |t|
    t.string   "user",               limit: 255
    t.string   "mobile",             limit: 255
    t.date     "birthday"
    t.boolean  "processed"
    t.boolean  "accepted"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "email",              limit: 255
    t.boolean  "gender"
    t.string   "id_num",             limit: 255
    t.string   "id_type",            limit: 255
    t.string   "province",           limit: 255
    t.string   "city",               limit: 255
    t.string   "address",            limit: 255
    t.boolean  "activated"
    t.boolean  "accepted_all_terms"
    t.string   "metlife_msg",        limit: 255
    t.string   "free_insurance_no",  limit: 255
  end

end
