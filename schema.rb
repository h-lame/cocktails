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

ActiveRecord::Schema.define(version: 0) do

  create_table "Account", primary_key: "account_id", force: :cascade do |t|
    t.text "name", null: false
    t.text "sort_string"
    t.text "picture", null: false
    t.index ["sort_string"], name: "ix_Account_sort_string", unique: true
  end

  create_table "Characteristic", primary_key: "characteristic_id", force: :cascade do |t|
    t.text "category", null: false
    t.text "label", null: false
    t.index ["category", "label"], name: "idx_characteristic_table_01", unique: true
  end

  create_table "Image", primary_key: "image_id", force: :cascade do |t|
    t.text "image_name", null: false
    t.binary "image"
    t.binary "thumbnail"
    t.index ["image_name"], name: "ix_Image_image_name", unique: true
  end

  create_table "Ingredient", primary_key: "ingredient_id", force: :cascade do |t|
    t.text "hashed_ingredient_id", null: false
    t.text "htmlfrag", null: false
    t.text "bodytagextra", null: false
    t.boolean "proprietary", null: false
    t.text "identity", null: false
    t.text "description"
    t.text "category", default: "booze", null: false
    t.index ["category"], name: "ix_ingredient_category"
    t.index ["hashed_ingredient_id"], name: "ix_Ingredient_hashed_ingredient_id", unique: true
  end

  create_table "Recipe", primary_key: "recipe_id", force: :cascade do |t|
    t.text "canonical_title", null: false
    t.text "srch_canonical_title", null: false
    t.text "precooked_ingredients_summary"
    t.text "srch_precooked_ingredients_summary"
    t.index ["canonical_title"], name: "ix_Recipe_canonical_title", unique: true
    t.index ["srch_canonical_title"], name: "ix_Recipe_srch_canonical_title", unique: true
  end

  create_table "RecipeFormulation", primary_key: "recipe_formulation_id", force: :cascade do |t|
    t.text "hashed_recipe_formulation_id", null: false
    t.text "hashed_recipe_formulation_id2", null: false
    t.text "presentation"
    t.integer "recipe_id", null: false
    t.text "original_title", null: false
    t.text "canonical_title", null: false
    t.text "list_image_url", null: false
    t.text "detail_image_url", null: false
    t.text "xmlcitation", null: false
    t.text "citation_image_url"
    t.text "xmlbody"
    t.integer "year", null: false
    t.integer "account_id"
    t.text "ingredients_list", null: false
    t.text "app_id", null: false
    t.index ["account_id"], name: "ix_RecipeFormulation_account_id"
    t.index ["canonical_title"], name: "ix_RecipeFormulation_canonical_title"
    t.index ["recipe_id"], name: "ix_RecipeFormulation_recipe_id"
  end

  create_table "RecipeFormulation_Characteristic", primary_key: ["recipe_formulation_id", "characteristic_id"], force: :cascade do |t|
    t.integer "recipe_formulation_id", null: false
    t.integer "characteristic_id", null: false
    t.float "rank"
    t.index ["recipe_formulation_id", "characteristic_id"], name: "idx_recipe_formulation_characteristic_table_01", unique: true
  end

  create_table "RecipeImageURL", primary_key: "recipe_image_url_id", force: :cascade do |t|
    t.integer "recipe_formulation_id", null: false
    t.text "recipe_image_url", null: false
    t.float "recipe_image_width", null: false
    t.float "recipe_image_height", null: false
    t.text "recipe_image_url_target_url"
    t.integer "recipe_image_ordinal", null: false
    t.index ["recipe_formulation_id"], name: "ix_RecipeImageURL_recipe_formulation_id"
  end

  create_table "Recipe_Characteristic", primary_key: ["recipe_id", "characteristic_id"], force: :cascade do |t|
    t.integer "recipe_id", null: false
    t.integer "characteristic_id", null: false
    t.float "rank"
    t.index ["characteristic_id"], name: "ix_Recipe_Characteristic_characteristic_id"
    t.index ["recipe_id", "characteristic_id"], name: "idx_recipe_characteristic_table_01", unique: true
  end

# Could not dump table "SrchRecipe" because of following StandardError
#   Unknown type '' for column 'srch_canonical_title'

# Could not dump table "SrchRecipe_content" because of following StandardError
#   Unknown type '' for column 'c0srch_canonical_title'

  create_table "SrchRecipe_segdir", primary_key: ["level", "idx"], force: :cascade do |t|
    t.integer "level"
    t.integer "idx"
    t.integer "start_block"
    t.integer "leaves_end_block"
    t.integer "end_block"
    t.binary "root"
  end

  create_table "SrchRecipe_segments", primary_key: "blockid", force: :cascade do |t|
    t.binary "block"
  end

  create_table "StaticSchemaMeta", primary_key: "schema_id", force: :cascade do |t|
    t.integer "version", null: false
    t.datetime "datetime", null: false
  end

  create_table "barwares", force: :cascade do |t|
    t.text "name", null: false
    t.text "synonyms"
  end

  create_table "recipe_formulation_ingredients", force: :cascade do |t|
    t.integer "recipe_formulation_id", null: false
    t.integer "ingredient_id"
    t.integer "ingredient_recipe_formulation_id"
    t.text "name", null: false
    t.index ["ingredient_id"], name: "ix_recipe_formulation_ingredients_ingredient_id"
    t.index ["ingredient_recipe_formulation_id"], name: "ix_recipe_formulation_ingredients_ingredient_recipe_formulation_id"
    t.index ["recipe_formulation_id"], name: "ix_recipe_formulation_ingredients_recipe_formulation_id"
  end

end
