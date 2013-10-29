class Spouse < DatabaseTemplate
  attr_reader :id, :values, :partner1_id, :partner2_id, :status

  def initialize(values)
    @id = values['id']
    @partner1_id = values['partner1_id'].to_i
    @partner2_id = values['partner2_id'].to_i
    @status = values['status']
    @values = { 'id' => @id, 'partner2_id' => @partner2_id, 'partner1_id' => partner1_id, 'status' => @status }
    @table_name = 'spouses'

  end

  def self.all
    super('spouses', :Spouse)
  end

  def save
    results = DB.exec("INSERT INTO #{@table_name} (partner1_id) VALUES ('#{@partner1_id}') RETURNING id;")
    @id = results.first['id']
    @values['id'] = @id  
    @values.each do |key, value|
      unless value.nil? || value == ""
        DB.exec("UPDATE #{@table_name} SET #{key} = '#{value}' WHERE id = #{@id};")
      end
    end
  end
end