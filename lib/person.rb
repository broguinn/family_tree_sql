class Person < DatabaseTemplate

  def initialize(values)
    super(values)
    @table_name = 'people'
  end

  def self.all
    super('people', :Person)
  end

  def spouses
    results = DB.exec("SELECT * FROM spouses WHERE partner1_id = #{@id};")
    partners = []
    results.each do |spouse|
      person_data = DB.exec("SELECT * FROM people WHERE id = #{spouse['partner2_id']};")
      person = Person.new(person_data.first)
      partners << person
    end
    partners
  end

  def relationship(partner)
    results = DB.exec("SELECT status FROM spouses WHERE partner1_id = #{@id} AND partner2_id = #{partner.id};")
    results.first['status']
  end

  def parents
    results = DB.exec("SELECT * FROM parents WHERE child_id = #{@id};")
    parents = []
    results.each do |parent|
      parent_data = DB.exec("SELECT * FROM people WHERE id = #{parent['parent_id']};")
      person = Person.new(parent_data.first)
      parents << person
    end
    parents
  end

  def children
    results = DB.exec("SELECT * FROM parents WHERE parent_id = #{@id};")
    children = []
    results.each do |child|
      child_data = DB.exec("SELECT * FROM people WHERE id = #{child['child_id']};")
      person = Person.new(child_data.first)
      children << person
    end
    children
  end

  def siblings
    results = DB.exec("SELECT * FROM siblings WHERE sibling1_id = #{@id};")
    siblings = []
    results.each do |sibling|
      sibling_data = DB.exec("SELECT * FROM people WHERE id = #{sibling['sibling2_id']};")
      person = Person.new(sibling_data.first)
      siblings << person
    end
    siblings
  end
end
