class DatabaseTemplate
  attr_reader :name, :id, :values, :table_name

  def initialize(values) 
    @name = values['name']
    @id = values['id']
    @values = { 'name' => @name, 'id' => @id }
  end

  def ==(other)
    @values == other.values
  end

  def save
    results = DB.exec("INSERT INTO #{@table_name} (name) VALUES ('#{@name}') RETURNING id;")
    @id = results.first['id']
    @values['id'] = @id  
    @values.each do |key, value|
      unless value.nil? || value == ""
        DB.exec("UPDATE #{@table_name} SET #{key} = '#{value}' WHERE id = #{@id};")
      end
    end
  end

  def self.all(table_name, class_sym)
    results = DB.exec("SELECT * FROM #{table_name};")
    things = []
    results.each do |result|
      things << Object.const_get(class_sym).new(result)
    end
    things
  end

  def delete
    DB.exec("DELETE FROM #{@table_name} WHERE id = #{@id};")
    # DB.exec("DELETE FROM inventory WHERE #{self.class}_id = #{@id}")
  end

  def get_members(table_name, class_sym, class_name)
    results = DB.exec("SELECT * FROM #{table_name} WHERE #{self.class}_id = #{@id};")
    members = []
    results.each do |result|
      # table_id = result["#{class_name}_id"]
      # data = DB.exec("SELECT * FROM #{table_name} WHERE id = #{table_id}")
      members << Object.const_get(class_sym).new(result)
    end
    members
  end
end