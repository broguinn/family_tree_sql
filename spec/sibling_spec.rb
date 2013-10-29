require 'spec_helper'

describe Sibling do
  it 'is initialized with two siblingss' do
    sibling = Sibling.new({ 'sibling1_id' => 1, 'sibling2_id' => 2 })
    sibling.should be_an_instance_of Sibling
  end

  it 'has a sibling1_id' do
    sibling = Sibling.new({ 'sibling1_id' => 1, 'sibling2_id' => 2 })
    sibling.sibling1_id.should eq 1
  end

  it 'has a sibling2_id' do
    sibling = Sibling.new({ 'sibling1_id' => 1, 'sibling2_id' => 2 })
    sibling.sibling2_id.should eq 2
  end

  it 'is the same sibling if it has the same sibling ids' do
    sibling1 = Sibling.new({ 'sibling1_id' => 1, 'sibling2_id' => 2 })
    sibling2 = Sibling.new({ 'sibling1_id' => 1, 'sibling2_id' => 2 })
    sibling1.should eq sibling2
  end

  it 'starts off with no sibling relationships' do
    Sibling.all.should eq []
  end

  it 'saves itself to the database' do
    sibling = Sibling.new({ 'sibling1_id' => 1, 'sibling2_id' => 2 })
    sibling.save
    Sibling.all.should eq [sibling]
  end

  it 'is assigned an id after it is saved' do
    sibling = Sibling.new({ 'sibling1_id' => 1, 'sibling2_id' => 2 })
    sibling.save
    sibling.id.should_not be_nil
  end

  it 'is given an id upon initialization' do
    sibling = Sibling.new({ 'sibling1_id' => 1, 'sibling2_id' => 2 })
    sibling.save
    Sibling.all[0].id.should_not be_nil
  end

  it 'deletes a sibling from the database' do
    sibling = Sibling.new({ 'sibling1_id' => 1, 'sibling2_id' => 2 })
    sibling.save
    sibling.delete
    Sibling.all.should eq []
  end
end