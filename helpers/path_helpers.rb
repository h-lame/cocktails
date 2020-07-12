module PathHelpers
  def recipe_path(recipe)
    "/recipes/#{recipe.to_param}"
  end

  def ingredient_path(ingredient)
    "/ingredients/#{ingredient.to_param}"
  end

  def category_path(ingredient_category)
    "/ingredients/categories/#{ingredient_category.parameterize}"
  end

  def recipe_formulation_path(recipe_formulation)
    "/recipes/#{recipe_formulation.recipe.to_param}##{recipe_formulation.to_param}"
  end

  def constituent_part_path(constituent_part)
    case constituent_part
    when Ingredient
      ingredient_path(constituent_part)
    when RecipeFormulation
      recipe_formulation_path(constituent_part)
    when RecipeFormulationIngredient
      constituent_part_path(constituent_part.part)
    end
  end
end
