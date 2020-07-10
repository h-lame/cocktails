class Characteristic < ActiveRecord::Base
  self.table_name = 'Characteristic'

  has_many :recipe_characteristics
  has_many :recipe_formulation_characteristics
end

class Ingredient < ActiveRecord::Base
  self.table_name = 'Ingredient'
end

class Recipe < ActiveRecord::Base
  self.table_name = 'Recipe'

  has_many :recipe_formulations
  has_many :recipe_characteristics
  has_many :characteristics, through: :recipe_characteristics
end

class RecipeFormulation < ActiveRecord::Base
  self.table_name = 'RecipeFormulation'

  belongs_to :recipe
  has_many :recipe_formulation_characteristics
  has_many :characteristics, through: :recipe_formulation_characteristics
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

