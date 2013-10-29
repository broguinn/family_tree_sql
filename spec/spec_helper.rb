require 'rspec'
require 'database_template'
require 'person'
require 'parent'
require 'sibling'
require 'spouse'
require 'pg'
require 'pry'

DB = PG.connect(:dbname => 'family_tree_test')

RSpec.configure do |config|
  config.after(:each) do
    DB.exec("DELETE FROM people *;")
    DB.exec("DELETE FROM parents *;")
    DB.exec("DELETE FROM siblings *;")
    DB.exec("DELETE FROM spouses *;")
  end
end