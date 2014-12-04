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

ActiveRecord::Schema.define(version: 20141204115047) do

  create_table "albums", force: true do |t|
    t.string  "name"
    t.string  "picture"
    t.boolean "active",  default: true
  end

  create_table "albums_users", force: true do |t|
    t.integer "album_id"
    t.integer "user_id"
  end

  create_table "photos", force: true do |t|
    t.string  "picture"
    t.string  "description"
    t.string  "date"
    t.integer "album_id"
  end

  create_table "users", force: true do |t|
    t.string  "name"
    t.string  "password_digest"
    t.boolean "active",          default: true
  end

end
