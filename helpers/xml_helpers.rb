module XmlHelpers
  def tidy_xml(xml)
    link_up_ingredients(xml)
    extract_measures(xml)
    xml
  end

  def link_up_ingredients(xml)
    xml.css('ing').each do |ingredient_tag|
      part = to_ingredient_or_recipe(ingredient_tag)
      ingredient_tag.replace(%{<a href="#{constituent_part_path(part)}">#{ingredient_tag.children.to_html}</a>})
    end
    xml
  end

  def extract_measures(xml)
    xml.css('meas').each do |measure_tag|
      measure_data = Hash[['oz', 'cl', 'ml', 'gill'].map { |measurement| [measurement, stringify_fractions(measure_tag.attribute(measurement).value)] }]
      measures = measure_data.map do |unit, volume|
        %{<span class="#{unit}">#{volume}</span>}
      end
      measure_tag.replace(%{<span class="measure">#{measures.join}</span>})
    end
    xml
  end

  def to_ingredient_or_recipe(ingredient_tag)
    case ingredient_tag.attribute('type').value
    when 'ingredient'
      Ingredient.from_tag(ingredient_tag)
    when 'recipe'
      RecipeFormulation.from_tag(ingredient_tag)
    end
  end
end
