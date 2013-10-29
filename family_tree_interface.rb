require 'pg'
require 'pry'
require './lib/database_template'
require './lib/person'
require './lib/spouse'
require './lib/parent'
require './lib/sibling'


DB = PG.connect( :dbname => 'family_tree')

def init
  puts `clear`
  puts ""
  puts ""
  puts "        Family Tree"
  puts ""
  gets.chomp
  main
end

def main
  puts `clear`
  print_people
  puts ""
  puts "Select a person with their index, [a]dd a person, or e[x]it"
  selection = gets.chomp.downcase.strip
  if selection.to_i > 0 && selection.to_i <= Person.all.length
    person_menu(Person.all[selection.to_i - 1])
  elsif selection == 'a'
    add_person
    main
  elsif selection == 'x'
    puts "Goodbye"
  else
    main
  end
end

def print_people
  Person.all.each_with_index do |person, index|
    puts "#{index + 1}. #{person.name}"
  end
end

def person_menu(person)
  print `clear`
  puts "Name: #{person.name}"
  puts ""
  puts "Spouses: "
  person.spouses.each do |spouse| 
    print "  #{spouse.name}"
    puts " (#{person.relationship(spouse)})"
  end
  puts ""
  puts "Parents: "
  person.parents.each do |parent|
    puts "  #{parent.name}"
  end
  puts ""
  puts "Children: "
  person.children.each do |child|
    puts "  #{child.name}"
  end
  puts ""
  puts "Grandparents: "
  person.parents.each do |parent|
    parent.parents.each do |grandparent|
      puts "  #{grandparent.name}"
    end
  end
  puts ""
  puts "Grandchildren: "
  person.children.each do |child|
    child.children.each do |grandchild|
      puts "  #{grandchild.name}"
    end
  end
  puts ""
  puts "Siblings: "
  person.siblings.each do |sibling|
    puts "  #{sibling.name}"
  end
  puts ""
  puts "Cousins: "
  person.parents.each do |parent|
    parent.siblings.each do |aunt|
      aunt.children.each do |cousin|
        puts "  #{cousin.name}"
      end
    end
  end
  puts ""
  puts "Aunts and Uncles: "
  person.parents.each do |parent|
    parent.siblings.each do |aunt|
      puts "  #{aunt.name}"
    end
  end
  puts ""

  puts "Add a [s]pouse, add a [p]arent, [c]hild, s[i]bling or [m]ain menu"
  puts "Remove a [r]elationship, a c[h]ild, a si[b]ling, or a p[a]rent"
  selection = gets.chomp.downcase
  if selection == 's'
    add_spouse(person)
    person_menu(person)
  elsif selection == 'p'
    add_parent(person)
    person_menu(person)
  elsif selection == 'c'
    add_child(person)
    person_menu(person)
  elsif selection == 'i'
    add_sibling(person)
    person_menu(person)
  elsif selection == 'r'
    remove_spouse(person)
    person_menu(person)
  elsif selection == 'h'
    remove_child(person)
    person_menu(person)
  elsif selection == 'a'
    remove_parent(person)
    person_menu(person)
  elsif selection == 'b'
    remove_sibling(person)
    person_menu(person)
  elsif selection == 'm'
    main
  else
    person_menu(person)
  end
end

def add_spouse(person)
  print `clear`
  print_people
  puts ""
  puts "Select a new spouse with their index, or person [m]enu"
  selection = gets.chomp.downcase.strip
  if selection.to_i > 0 && selection.to_i <= Person.all.length
    puts "Enter the realtionship status:"
    status = gets.chomp
    spouse_id = Person.all[selection.to_i - 1].id
    spouse = Spouse.new({ 'partner1_id' => person.id, 'partner2_id' => spouse_id, 'status' => status})
    spouse.save
    spouse1 = Spouse.new({ 'partner1_id' => spouse_id, 'partner2_id' => person.id, 'status' => status})
    spouse1.save
    person_menu(person)
  elsif selection == 'm'
  else
    add_spouse(person)
  end
end

def add_parent(person)
  print `clear`
  print_people
  puts ""
  puts "Select a new parent with their index, or person [m]enu"
  selection = gets.chomp.downcase.strip
  if selection.to_i > 0 && selection.to_i <= Person.all.length
    parent_id = Person.all[selection.to_i - 1].id
    parent = Parent.new({ 'parent_id' => parent_id, 'child_id' => person.id})
    parent.save
  elsif selection == 'm'
  else
    add_parent(person)
  end
end

def add_child(person)
  print `clear`
  print_people
  puts ""
  puts "Select a new child with their index, or person [m]enu"
  selection = gets.chomp.downcase.strip
  if selection.to_i > 0 && selection.to_i <= Person.all.length
    child_id = Person.all[selection.to_i - 1].id
    child = Parent.new({ 'parent_id' => person.id, 'child_id' => child_id})
    child.save
  elsif selection == 'm'
  else
    add_child(person)
  end
end

def add_sibling(person)
  print `clear`
  print_people
  puts ""
  puts "Select a new sibling with their index, or person [m]enu"
  selection = gets.chomp.downcase.strip
  if selection.to_i > 0 && selection.to_i <= Person.all.length
    sibling_id = Person.all[selection.to_i - 1].id
    sibling = Sibling.new({ 'sibling1_id' => person.id, 'sibling2_id' => sibling_id})
    sibling.save
    sibling1 = Sibling.new({ 'sibling1_id' => sibling_id, 'sibling2_id' => person.id})
    sibling1.save
    person_menu(person)
  elsif selection == 'm'
  else
    add_sibling(person)
  end
end

def add_person
  print `clear`
  puts "Enter a name:"
  name = gets.chomp
  Person.new({ 'name' => name}).save
end

def remove_spouse(person)
  print `clear`
  puts "Spouses: "
  person.spouses.each_with_index do |spouse, id|
    puts "  #{id + 1}. #{spouse.name}"
  end
  puts ""
  puts "Select a spouse to remove with index, or person [m]enu"
  selection = gets.chomp.downcase.strip
  if selection.to_i > 0 && selection.to_i <= person.spouses.length
    spouse_id = person.spouses[selection.to_i - 1].id
    relationship1 = DB.exec("SELECT * FROM spouses WHERE partner1_id = #{person.id} AND partner2_id = #{spouse_id};")
    relationship2 = DB.exec("SELECT * FROM spouses WHERE partner2_id = #{person.id} AND partner1_id = #{spouse_id};")
    Spouse.new(relationship1.first).delete
    Spouse.new(relationship2.first).delete
  elsif selection == 'm'
  else
    remove_spouse(person)
  end
end

def remove_child(person)
  print `clear`
  puts "Children: " 
  person.children.each_with_index do |child, id|
    puts " #{id + 1}. #{child.name}"
  end
  puts ""
  puts "Select a child to remove with index, or person [m]enu"
  selection = gets.chomp.downcase.strip
  if selection.to_i > 0 && selection.to_i <= person.children.length
    child_id = person.children[selection.to_i - 1].id
    parentage = DB.exec("SELECT * FROM parents WHERE parent_id = #{person.id;}")
    Parent.new(parentage.first).delete
  elsif selection == 'm'
  else
    remove_child(person)
  end
end

def remove_parent(person)
  print `clear`
  puts "Parents: "
  person.parents.each_with_index do |parent, id|
    puts " #{id +1}. #{parent.name}"
  end
  puts ""
  puts "Select a parent to remove with index, or person [m]enu"
  selection = gets.chomp.downcase.strip
  if selection.to_i > 0 && selection.to_i <= person.parents.length
    child_id = person.parents[selection.to_i - 1].id
    parentage = DB.exec("SELECT * FROM parents WHERE parent_id = #{person.id;}")
    Sibling.new(parentage.first).delete
  elsif selection == 'm'
  else
    remove_parent(person)
  end
end


def remove_sibling(person)
  print `clear`
  puts "Siblings: "
  person.siblings.each_with_index do |sibling, id|
    puts " #{id +1}. #{sibling.name}"
  end
  puts ""
  puts "Select a sibling to remove with index, or person [m]enu"
  selection = gets.chomp.downcase.strip
  if selection.to_i > 0 && selection.to_i <= person.siblings.length
    child_id = person.siblings[selection.to_i - 1].id
    siblinghood = DB.exec("SELECT * FROM siblings WHERE sibling1_id = #{person.id;}")
    Sibling.new(siblinghood.first).delete
  elsif selection == 'm'
  else
    remove_sibling(person)
  end
end

init




