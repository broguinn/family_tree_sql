class Sibling < DatabaseTemplate
    attr_reader :id, :values, :sibling1_id, :sibling2_id

  def initialize(values)
    @id = values['id']
    @sibling1_id = values['sibling1_id'].to_i
    @sibling2_id = values['sibling2_id'].to_i
    @values = { 'id' => @id, 'sibling2_id' => @sibling2_id, 'sibling1_id' => sibling1_id }
    @table_name = 'siblings'
  end

  def self.all
    super('siblings', :Sibling)
  end

  def save
    results = DB.exec("INSERT INTO #{@table_name} (sibling1_id) VALUES ('#{@sibling1_id}') RETURNING id;")
    @id = results.first['id']
    @values['id'] = @id  
    @values.each do |key, value|
      unless value.nil? || value == ""
        DB.exec("UPDATE #{@table_name} SET #{key} = '#{value}' WHERE id = #{@id};")
      end
    end
  end
end