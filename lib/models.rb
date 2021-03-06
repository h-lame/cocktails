class CocktailRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.insensitive_order(**columns)
    order(
      Arel.sql(
        columns.map { |column, dir| "#{table_name}.#{column} COLLATE NOCASE #{dir}" }.join(', ')
      )
    )
  end
end

class Characteristic < CocktailRecord
  self.table_name = 'Characteristic'

  scope :category_order, -> { insensitive_order(category: :asc, label: :asc) }
  scope :alpha_order, -> { insensitive_order(label: :asc) }

  enum category: { base: 'base', flavour: 'flavor', ingredient: 'ingredient', tagging: 'tag', type: 'type' }
  categories.each do |name, value|
    scope :"without_#{name.pluralize}", -> { where.not(category: value) }
  end

  has_many :recipe_characteristics
  has_many :recipe_formulation_characteristics

  def ingredient
    return nil unless category == 'base'

    Ingredient.where('lower(identity) = ?', label.downcase).first
  end

  def to_param
    "#{category}/#{label.parameterize}"
  end
end

class Barware < CocktailRecord
  scope :alpha_order, -> { insensitive_order(name: :asc) }

  has_many :recipe_formulation_barwares
  has_many :recipe_formulations, through: :recipe_formulation_barwares

  def synonyms_array=(new_array)
    self.synonyms = CSV.generate_line(Set.new(new_array)).chomp
  end

  def synonyms_array
    Set.new(CSV.parse_line(self.synonyms || '') || [])
  end

  def to_param
    name.parameterize
  end
end

class BarwareImage < CocktailRecord
  self.table_name = 'Image'

  scope :alpha_order, -> { insensitive_order(image_name: :asc) }

  def title
    image_name.gsub(/\Aicon\.(.*)\.bar\Z/, '\1')
  end

  def to_param
    title.parameterize
  end

  def img_src
    "/images/barware/#{image_name}"
  end
end

class Ingredient < CocktailRecord
  self.table_name = 'Ingredient'

  scope :alpha_order, -> { insensitive_order(identity: :asc) }

  has_many :recipe_formulation_ingredients
  has_many :recipe_formulations, through: :recipe_formulation_ingredients

  def self.categories
    insensitive_order(category: :asc).select('distinct category').map &:category
  end

  def self.from_tag(tag)
    find_by(hashed_ingredient_id: tag.attribute('id').value)
  end

  def to_param
    identity.parameterize
  end
end

class Recipe < CocktailRecord
  self.table_name = 'Recipe'

  scope :alpha_order, -> { insensitive_order(canonical_title: :asc) }

  scope :with_characteristic, ->(characteristic) do
    with_characteristics = self.includes(:recipe_characteristics, recipe_formulations: :recipe_formulation_characteristics)
    with_characteristics
      .where(RecipeFormulation_Characteristic: { characteristic_id: characteristic.id })
      .or(
        with_characteristics.where(Recipe_Characteristic: { characteristic_id: characteristic.id })
      )
  end

  has_many :recipe_formulations, -> { order(year: :desc) }
  has_many :recipe_characteristics
  has_many :characteristics, -> { without_ingredients }, through: :recipe_characteristics

  has_many :ingredients, -> { distinct }, through: :recipe_formulations

  def title
    canonical_title
  end

  def ingredient_summary
    precooked_ingredients_summary
  end

  def to_param
    canonical_title.parameterize
  end

  def ingredients_metadata
    ingredients.map(&:identity).join ', '
  end

  def categorised_characteristics
    characteristics.category_order.group_by(&:category)
  end
end

class RecipeFormulation < CocktailRecord
  self.table_name = 'RecipeFormulation'

  def title
    "#{canonical_title} (#{year})"
  end

  belongs_to :recipe
  has_many :recipe_formulation_characteristics
  has_many :characteristics, -> { without_ingredients }, through: :recipe_formulation_characteristics
  has_many :recipe_formulation_ingredients
  has_many :ingredients, through: :recipe_formulation_ingredients
  has_many :recipe_formulation_barwares
  has_many :barwares, through: :recipe_formulation_barwares

  def categorised_characteristics
    characteristics.category_order.group_by(&:category)
  end

  def self.from_tag(tag)
    find_by(hashed_recipe_formulation_id2: tag.attribute('id').value)
  end

  def xmlbody_as_xml
    Nokogiri::XML.fragment(xmlbody)
  end

  def to_param
    hashed_recipe_formulation_id2
  end
end

class RecipeFormulationCharacteristic < CocktailRecord
  self.table_name = 'RecipeFormulation_Characteristic'

  belongs_to :recipe_formulation
  belongs_to :characteristic
end

class RecipeFormulationBarware < CocktailRecord
  belongs_to :recipe_formulation
  belongs_to :barware
end

class RecipeFormulationIngredient < CocktailRecord
  belongs_to :recipe_formulation
  belongs_to :ingredient
  belongs_to :ingredient_recipe_formulation, class_name: 'RecipeFormulation', foreign_key: :ingredient_recipe_formulation_id

  scope :with_part, -> { includes(:ingredient, :ingredient_recipe_formulation) }

  def part
    ingredient || ingredient_recipe_formulation
  end
end

class RecipeCharacteristic < CocktailRecord
  self.table_name = 'Recipe_Characteristic'

  belongs_to :recipe
  belongs_to :characteristic
end

