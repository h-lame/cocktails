require './setup_data'
require './lib/models'
require 'nokogiri'
require 'set'
require 'csv'

def collect_tags(fragment, collection, tag_name)
  fragment.css(tag_name).each do |tag|
    collection << tag
  end
end

collected = []
Barware.transaction do
  Barware.delete_all
  Recipe.includes(:recipe_formulations).alpha_order.all.each do |recipe|
    recipe.recipe_formulations.each do |formulation|
      body = formulation.xmlbody
      xmldoc = Nokogiri::XML.fragment(body)
      collect_tags(xmldoc, collected, 'bwr').each do |bwr|
        bwr_id = bwr.attribute('id').value
        bwr_text = bwr.text
        bwr = Barware.find_by(id: bwr_id)
        if bwr.blank?
          Barware.create!(id: bwr_id, name: bwr_text)
        elsif bwr.name != bwr_text
          synonyms = bwr.synonyms_array
          synonyms << bwr_text
          bwr.update!(synonyms_array: synonyms)
        end
      end
    end
  end
end
