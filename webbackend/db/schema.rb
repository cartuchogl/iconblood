# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100701151603) do

  create_table "backgrounds", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "campaigns", :force => true do |t|
    t.integer  "background_id"
    t.integer  "image_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "environments", :force => true do |t|
    t.string   "name"
    t.integer  "image_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "factions", :force => true do |t|
    t.string   "name"
    t.integer  "image_id"
    t.integer  "background_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "games", :force => true do |t|
    t.integer  "environment_id"
    t.integer  "level_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "images", :force => true do |t|
    t.string   "title"
    t.string   "data_file_name"
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.datetime "data_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "levels", :force => true do |t|
    t.integer  "position"
    t.string   "name"
    t.integer  "environment_id"
    t.integer  "campaign_id"
    t.integer  "pre_background_id"
    t.integer  "post_background_id"
    t.integer  "image_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pages", :force => true do |t|
    t.integer  "position"
    t.integer  "image_id"
    t.integer  "background_id"
    t.text     "txt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "players", :force => true do |t|
    t.string   "alias"
    t.string   "email"
    t.integer  "image_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "squadron_units", :force => true do |t|
    t.integer  "squadron_id"
    t.integer  "unit_id"
    t.integer  "level"
    t.integer  "exp"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "squadron_units_unit_options", :force => true do |t|
    t.integer  "squadron_unit_id"
    t.integer  "unit_option_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "squadrons", :force => true do |t|
    t.string   "name"
    t.integer  "player_id"
    t.integer  "game_id"
    t.integer  "image_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "unit_options", :force => true do |t|
    t.string   "name"
    t.integer  "unit_id"
    t.integer  "cost"
    t.integer  "move"
    t.integer  "force"
    t.integer  "skill"
    t.integer  "resistance"
    t.boolean  "fly"
    t.integer  "background_id"
    t.integer  "equip_type"
    t.integer  "use"
    t.integer  "quantity"
    t.integer  "image_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "units", :force => true do |t|
    t.string   "name"
    t.integer  "cost"
    t.integer  "faction_id"
    t.integer  "background_id"
    t.integer  "move"
    t.integer  "force"
    t.integer  "skill"
    t.integer  "resistance"
    t.integer  "move_type"
    t.integer  "max_equip"
    t.integer  "image_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "password_hash"
    t.string   "password_salt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
