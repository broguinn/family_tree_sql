require 'spec_helper'

describe Person do
  it 'is initialized with a name' do
    person = Person.new({ 'name' => 'Sarah Struther' })
    person.should be_an_instance_of Person
  end

  it 'has a name' do
    person = Person.new({ 'name' => 'Hal Incandenza' })
    person.name.should eq 'Hal Incandenza'
  end

  it 'is the same person if it has the same name' do
    person1 = Person.new({ 'name' => 'Charles Tavis' })
    person2 = Person.new({ 'name' => 'Charles Tavis' })
    person1.should eq person2
  end

  it 'starts off with no people' do
    Person.all.should eq []
  end

  it 'saves itself to the database' do
    person = Person.new({ 'name' => 'Michael Pemulis' })
    person.save
    Person.all.should eq [person]
  end

  it 'is assigned an id after it is saved' do
    person = Person.new({ 'name' => 'Jay Gatsby' })
    person.save
    person.id.should_not be_nil
  end

  it 'is given an id upon initialization' do
    person = Person.new({ 'name' => 'Steve Struck' })
    person.save
    Person.all[0].id.should_not be_nil
  end

  it 'deletes a person from the database' do
    person = Person.new({ 'name' => 'Dorian Grey' })
    person.save
    person.delete
    Person.all.should eq []
  end

  it "can get its spouse" do
    person1 = Person.new({'name' => 'Jay Incandenza'})
    person2 = Person.new({'name' => 'Avril Incandenza'})
    person1.save
    person2.save
    spouse = Spouse.new({'partner1_id' => person1.id, 'partner2_id' => person2.id})
    spouse.save
    spouse2 = Spouse.new({'partner1_id' => person2.id, 'partner2_id' => person1.id})
    spouse2.save
    person1.spouses.should eq [person2]
  end

  it "can get its parents" do
    person1 = Person.new({'name' => 'Jay Incandenza'})
    person2 = Person.new({'name' => 'Avril Incandenza'})
    person3 = Person.new({'name' => 'Hal Incandenza'})
    person1.save
    person2.save
    person3.save
    parent = Parent.new({'parent_id' => person1.id, 'child_id' => person3.id})
    parent.save
    parent2 = Parent.new({'parent_id' => person2.id, 'child_id' => person3.id})
    parent2.save
    person3.parents.should eq [person1, person2]
  end

  it "can get its children" do
    person1 = Person.new({'name' => 'Jay Incandenza'})
    person2 = Person.new({'name' => 'Orin Incandenza'})
    person3 = Person.new({'name' => 'Hal Incandenza'})
    person1.save
    person2.save
    person3.save
    parent = Parent.new({'parent_id' => person1.id, 'child_id' => person2.id})
    parent.save
    parent2 = Parent.new({'parent_id' => person1.id, 'child_id' => person3.id})
    parent2.save
    person1.children.should eq [person2, person3]
  end

  it "can get its siblings" do
    person1 = Person.new({'name' => 'Mario Incandenza'})
    person2 = Person.new({'name' => 'Orin Incandenza'})
    person3 = Person.new({'name' => 'Hal Incandenza'})
    person1.save
    person2.save
    person3.save
    sibling = Sibling.new({'sibling1_id' => person1.id, 'sibling2_id' => person2.id})
    sibling.save
    sibling2 = Sibling.new({'sibling1_id' => person1.id, 'sibling2_id' => person3.id})
    sibling2.save
    person1.siblings.should eq [person2, person3]
  end

  it "returns the status of a relationship" do
    person1 = Person.new({'name' => 'Jay Incandenza'})
    person2 = Person.new({'name' => 'Avril Incandenza'})
    person1.save
    person2.save
    spouse = Spouse.new({'partner1_id' => person1.id, 'partner2_id' => person2.id, 'status' => 'widowed'})
    spouse.save
    spouse2 = Spouse.new({'partner1_id' => person2.id, 'partner2_id' => person1.id, 'status' => 'deceased'})
    spouse2.save
    person1.relationship(person2).should eq "widowed"
  end
end



