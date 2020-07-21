# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20_200_718_050_528) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'connections', force: :cascade do |t|
    t.inet 'ip'
    t.bigint 'user_id'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index %w[ip user_id], name: 'index_connections_on_ip_and_user_id', unique: true
    t.index ['user_id'], name: 'index_connections_on_user_id'
  end

  create_table 'posts', force: :cascade do |t|
    t.string 'title'
    t.text 'content'
    t.inet 'ip'
    t.integer 'avg_rating'
    t.integer 'rating_count', default: 0
    t.integer 'rating_value', default: 0
    t.bigint 'user_id'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['avg_rating'], name: 'index_posts_on_avg_rating'
    t.index ['user_id'], name: 'index_posts_on_user_id'
  end

  create_table 'users', force: :cascade do |t|
    t.string 'username'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['username'], name: 'index_users_on_username'
  end
end
