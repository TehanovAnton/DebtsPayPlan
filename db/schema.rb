# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2023_08_02_123832) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "costs", force: :cascade do |t|
    t.string "costable_type"
    t.bigint "costable_id"
    t.float "cost_value", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "group_id"
    t.string "type", default: "Cost", null: false
    t.bigint "debt_id"
    t.index ["costable_type", "costable_id"], name: "index_costs_on_costable"
    t.index ["debt_id"], name: "index_costs_on_debt_id"
    t.index ["group_id"], name: "index_costs_on_group_id"
  end

  create_table "debt_steps", force: :cascade do |t|
    t.bigint "debter_id"
    t.bigint "recipient_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "group_debts_pay_plan_id"
    t.float "pay_value", null: false
    t.index ["debter_id"], name: "index_debt_steps_on_debter_id"
    t.index ["group_debts_pay_plan_id"], name: "index_debt_steps_on_group_debts_pay_plan_id"
    t.index ["recipient_id"], name: "index_debt_steps_on_recipient_id"
  end

  create_table "debts", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.decimal "debt_value", precision: 5, scale: 2, null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_debts_on_user_id"
  end

  create_table "group_debts_pay_plans", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "group_members", force: :cascade do |t|
    t.string "group_memberable_type", null: false
    t.bigint "group_memberable_id", null: false
    t.bigint "group_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "type", default: "GroupMember", null: false
    t.index ["group_id"], name: "index_group_members_on_group_id"
    t.index ["group_memberable_type", "group_memberable_id"], name: "index_group_members_on_group_memberable"
  end

  create_table "groups", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "costs", "debts"
  add_foreign_key "costs", "groups"
  add_foreign_key "debt_steps", "group_debts_pay_plans"
  add_foreign_key "debts", "users"
end
