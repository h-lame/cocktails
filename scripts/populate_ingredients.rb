require './setup_data'
require './lib/models'
require 'nokogiri'

happened = {}
Ingredient.transaction do
  Ingredient.alpha_order.all.each.with_index do |ing, idx|
    puts "Looking at #{idx}: #{ing.identity}"
    doc = Nokogiri::HTML.fragment(ing.htmlfrag)

    things = {from_category: ing.category, from_description: ing.description}
    ing.category = doc.css('div#headercenter div#category').text.downcase

    things[:to_category] = ing.category

    description = doc.css('#body')
    description.css('[href]').map do |x|
      u = URI.parse(x.attribute('href').value)
      linked_ing = Ingredient.find_by(hashed_ingredient_id: u.path.gsub(/\//,''))
      x.attribute('href').value = "/ingredients/#{linked_ing.to_param}"
    end

    ing.description = description.children.to_html.gsub("\t", '').gsub(/\A\n|\n\Z/, '')

    things[:to_description] = ing.description

    ing.save!
    happened[ing.identity] = things
  end
end

puts happened.count
# puts happened.inspect
