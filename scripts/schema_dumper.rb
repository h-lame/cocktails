require './setup_data'

File.open('./schema.rb', 'w:utf8') { |f| ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, f) }
