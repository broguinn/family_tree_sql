class Parent < DatabaseTemplate

  attr_reader :parent_id, :child_id

  def initialize(values)
    @id = values['id']
    @parent_id = values['parent_id'].to_i
    @child_id = values['child_id'].to_i
    @values = { 'id' => @id, 'child_id' => @child_id, 'parent_id' => parent_id }
    @table_name = 'parents'
  end

  def self.all
    super('parents', :Parent)
  end

  def save
    results = DB.exec("INSERT INTO #{@table_name} (parent_id) VALUES ('#{@parent_id}') RETURNING id;")
    @id = results.first['id']
    @values['id'] = @id
    @values.each do |key, value|
      unless value.nil? || value == ""
        DB.exec("UPDATE #{@table_name} SET #{key} = '#{value}' WHERE id = #{@id};")
      end
    end
  end
end
