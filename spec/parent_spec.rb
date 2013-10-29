require 'spec_helper'

describe Parent do
  it 'is initialized with a parent and child' do
    parent = Parent.new({ 'parent_id' => 1, 'child_id' => 2 })
    parent.should be_an_instance_of Parent
  end

  it 'has a parent_id' do
    parent = Parent.new({ 'parent_id' => 1, 'child_id' => 2 })
    parent.parent_id.should eq 1
  end

  it 'has a child_id' do
    parent = Parent.new({ 'parent_id' => 1, 'child_id' => 2 })
    parent.child_id.should eq 2
  end

  it 'is the same parent if it has the same parent/child ids' do
    parent1 = Parent.new({ 'parent_id' => 1, 'child_id' => 2 })
    parent2 = Parent.new({ 'parent_id' => 1, 'child_id' => 2 })
    parent1.should eq parent2
  end

  it 'starts off with no parent relationships' do
    Parent.all.should eq []
  end

  it 'saves itself to the database' do
    parent = Parent.new({ 'parent_id' => 1, 'child_id' => 2 })
    parent.save
    Parent.all.should eq [parent]
  end

  it 'is assigned an id after it is saved' do
    parent = Parent.new({ 'parent_id' => 1, 'child_id' => 2 })
    parent.save
    parent.id.should_not be_nil
  end

  it 'is given an id upon initialization' do
    parent = Parent.new({ 'parent_id' => 1, 'child_id' => 2 })
    parent.save
    Parent.all[0].id.should_not be_nil
  end

  it 'deletes a parent from the database' do
    parent = Parent.new({ 'parent_id' => 1, 'child_id' => 2 })
    parent.save
    parent.delete
    Parent.all.should eq []
  end
end