require './setup_data'
require './lib/models'
require 'nokogiri'

def collect_tags(fragment, tag_name, attr_filters, &block)
  fragment.xpath('*').each do |tag|
    if tag.name == tag_name
      collect_this = attr_filters.all? do |attr_k, attr_v|
        tag.attribute(attr_k)&.value == attr_v
      end
      block.call(tag) if collect_this
    end
    collect_tags(tag, tag_name, attr_filters, &block)
  end
end

RecipeFormulation.transaction do
  RecipeFormulationIngredient.delete_all
  Recipe.includes(:recipe_formulations).alpha_order.all.each do |recipe|
    recipe.recipe_formulations.each do |formulation|
      body = formulation.xmlbody
      xmldoc = Nokogiri::XML.fragment(body)
      collect_tags(xmldoc, 'ing', 'type' => 'recipe') do |ing_recipe|
        rf = RecipeFormulation.find_by(hashed_recipe_formulation_id2: ing_recipe.attribute('id').value)
        RecipeFormulationIngredient.create!(
          recipe_formulation: formulation,
          ingredient_recipe_formulation: rf,
          name: ing_recipe.text
        )
      end
      collect_tags(xmldoc, 'ing', 'type' => 'ingredient') do |ing_recipe|
        i = Ingredient.find_by(hashed_ingredient_id: ing_recipe.attribute('id').value)
        RecipeFormulationIngredient.create!(
          recipe_formulation: formulation,
          ingredient: i,
          name: ing_recipe.text
        )
      end
    end
  end
end
