class Ingredients < Middleman::Extension
  def initialize(app, options_hash={}, &block)
    super
  end

  def manipulate_resource_list(resources)
    resources.each do |resource|
      if resource.is_a?(Middleman::Sitemap::ProxyResource) && resource.target == 'recipes/recipe.html'
        recipe = resource.locals[:recipe]
        resource.add_metadata(
          options: {
            ingredients: recipe.ingredients_metadata,
            recipe_title: recipe.title
          }
        )
      end
    end

    resources
  end
end

::Middleman::Extensions.register(:ingredients, Ingredients)
