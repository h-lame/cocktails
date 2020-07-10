# Activate and configure extensions
# https://middlemanapp.com/advanced/configuration/#configuring-extensions

activate :autoprefixer do |prefix|
  prefix.browsers = "last 2 versions"
end

# Layouts
# https://middlemanapp.com/basics/layouts/

# Per-page layout changes
page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

# With alternative layout
# page '/path/to/file.html', layout: 'other_layout'

# Proxy pages
# https://middlemanapp.com/advanced/dynamic-pages/
# proxy(
#   '/this-page-has-no-template.html',
#   '/template-file.html',
#   locals: {
#     which_fake_page: 'Rendering a fake page with a local variable'
#   },
# )

require './setup_data'
require './lib/models'

# Helpers
# Methods defined in the helpers block are available in templates
# https://middlemanapp.com/basics/helper-methods/

helpers do
  def recipe_path(recipe)
    "/recipes/#{recipe.to_param}"
  end

  def ingredient_path(ingredient)
    "/ingredients/#{ingredient.to_param}"
  end

  def recipe_formulation_path(recipe_formulation)
    "/recipes/#{recipe_formulation.recipe.to_param}##{recipe_formulation.to_param}"
  end

  def recipe_formulation_part_path(recipe_formulation_ingredient)
    case recipe_formulation_ingredient.part
    when Ingredient
      ingredient_path(recipe_formulation_ingredient.part)
    when RecipeFormulation
      recipe_formulation_path(recipe_formulation_ingredient.part)
    end
  end
end

set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'
set :build_dir, 'public'

# Build-specific configuration
# https://middlemanapp.com/advanced/configuration/#environment-specific-settings
# configure :build do
#   activate :minify_css
#   activate :minify_javascript
# end

Recipe.alpha_order.all.each do |recipe|
  proxy "/recipes/#{recipe.to_param}/index.html", "/recipes/recipe.html", locals: { recipe: recipe }, ignore: true
end

Ingredient.alpha_order.all.each do |ingredient|
  proxy "/ingredients/#{ingredient.to_param}/index.html", "/ingredients/ingredient.html", locals: { ingredient: ingredient }, ignore: true
end