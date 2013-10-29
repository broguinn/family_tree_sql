require 'spec_helper'

describe Spouse do
  it 'is initialized with two partners' do
    spouse = Spouse.new({ 'partner1_id' => 1, 'partner2_id' => 2 })
    spouse.should be_an_instance_of Spouse
  end

  it 'has a partner1_id' do
    spouse = Spouse.new({ 'partner1_id' => 1, 'partner2_id' => 2 })
    spouse.partner1_id.should eq 1
  end

  it 'has a partner2_id' do
    spouse = Spouse.new({ 'partner1_id' => 1, 'partner2_id' => 2 })
    spouse.partner2_id.should eq 2
  end

  it 'is the same spouse if it has the same partner ids' do
    spouse1 = Spouse.new({ 'partner1_id' => 1, 'partner2_id' => 2 })
    spouse2 = Spouse.new({ 'partner1_id' => 1, 'partner2_id' => 2 })
    spouse1.should eq spouse2
  end

  it 'starts off with no spouse relationships' do
    Spouse.all.should eq []
  end

  it 'saves itself to the database' do
    spouse = Spouse.new({ 'partner1_id' => 1, 'partner2_id' => 2 })
    spouse.save
    Spouse.all.should eq [spouse]
  end

  it 'is assigned an id after it is saved' do
    spouse = Spouse.new({ 'partner1_id' => 1, 'partner2_id' => 2 })
    spouse.save
    spouse.id.should_not be_nil
  end

  it 'is given an id upon initialization' do
    spouse = Spouse.new({ 'partner1_id' => 1, 'partner2_id' => 2 })
    spouse.save
    Spouse.all[0].id.should_not be_nil
  end

  it 'deletes a spouse from the database' do
    spouse = Spouse.new({ 'partner1_id' => 1, 'partner2_id' => 2 })
    spouse.save
    spouse.delete
    Spouse.all.should eq []
  end


end