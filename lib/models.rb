class Characteristic < ActiveRecord::Base
  self.table_name = 'Characteristic'

  scope :category_order, -> { order(category: :desc, label: :asc) }

  has_many :recipe_characteristics
  has_many :recipe_formulation_characteristics
end

class Barware < ActiveRecord::Base
  scope :alpha_order, -> { order(name: :asc) }

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

class BarwareImage < ActiveRecord::Base
  self.table_name = 'Image'

  scope :alpha_order, -> { order(image_name: :asc) }

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

class Ingredient < ActiveRecord::Base
  self.table_name = 'Ingredient'

  scope :alpha_order, -> { order(identity: :asc) }

  has_many :recipe_formulation_ingredients
  has_many :recipe_formulations, through: :recipe_formulation_ingredients

  def self.from_tag(tag)
    find_by(hashed_ingredient_id: tag.attribute('id').value)
  end

  def to_param
    identity.parameterize
  end
end

class Recipe < ActiveRecord::Base
  self.table_name = 'Recipe'

  scope :alpha_order, -> { order(canonical_title: :asc) }

  has_many :recipe_formulations, -> { order(year: :desc) }
  has_many :recipe_characteristics
  has_many :characteristics, through: :recipe_characteristics

  def title
    canonical_title
  end

  def ingredient_summary
    precooked_ingredients_summary
  end

  def to_param
    canonical_title.parameterize
  end

  def categorised_characteristics
    characteristics.category_order.group_by(&:category)
  end
end

class RecipeFormulation < ActiveRecord::Base
  self.table_name = 'RecipeFormulation'

  def title
    "#{canonical_title} (#{year})"
  end

  belongs_to :recipe
  has_many :recipe_formulation_characteristics
  has_many :characteristics, through: :recipe_formulation_characteristics
  has_many :recipe_formulation_ingredients
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

class RecipeFormulationCharacteristic < ActiveRecord::Base
  self.table_name = 'RecipeFormulation_Characteristic'

  belongs_to :recipe_formulation
  belongs_to :characteristic
end

class RecipeFormulationBarware < ActiveRecord::Base
  belongs_to :recipe_formulation
  belongs_to :barware
end

class RecipeFormulationIngredient < ActiveRecord::Base
  belongs_to :recipe_formulation
  belongs_to :ingredient
  belongs_to :ingredient_recipe_formulation, class_name: 'RecipeFormulation', foreign_key: :ingredient_recipe_formulation_id

  scope :with_part, -> { includes(:ingredient, :ingredient_recipe_formulation) }

  def part
    ingredient || ingredient_recipe_formulation
  end
end

class RecipeCharacteristic < ActiveRecord::Base
  self.table_name = 'Recipe_Characteristic'

  belongs_to :recipe
  belongs_to :characteristic
end

