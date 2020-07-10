class Characteristic < ActiveRecord::Base
  self.table_name = 'Characteristic'

  scope :category_order, -> { order(category: :desc, label: :asc) }

  has_many :recipe_characteristics
  has_many :recipe_formulation_characteristics
end

class Ingredient < ActiveRecord::Base
  self.table_name = 'Ingredient'

  scope :alpha_order, -> { order(identity: :asc) }

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
    canonical_title
  end

  belongs_to :recipe
  has_many :recipe_formulation_characteristics
  has_many :characteristics, through: :recipe_formulation_characteristics

  def categorised_characteristics
    characteristics.category_order.group_by(&:category)
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

class RecipeCharacteristic < ActiveRecord::Base
  self.table_name = 'Recipe_Characteristic'

  belongs_to :recipe
  belongs_to :characteristic
end

