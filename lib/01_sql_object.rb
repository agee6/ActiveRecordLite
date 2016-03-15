require_relative 'db_connection'
require 'active_support/inflector'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject
  def self.columns
    # ...
      if @cols.nil?
        cols = DBConnection.execute2(<<-SQL)
          SELECT
            *
          FROM
            #{table_name}
        SQL


        @cols = cols[0].map {|obj| obj.to_sym}
      else
        @cols
      end





  end
  # def underscore(camel_cased_word)
  #    camel_cased_word.to_s.gsub(/::/, '/').
  #      gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
  #      gsub(/([a-z\d])([A-Z])/,'\1_\2').
  #      tr("-", "_").
  #      downcase
  # end

  def self.finalize!
    cols = columns
    cols.each do |col|
      #met_name = "#{col}"
      define_method(col) do
        get_name = "@#{col}"
        self.attributes[col]
        #instance_variable_get(get_name)
      end
      set_met = "#{col}="
      define_method(set_met) do |obj|
        name_set = "@#{col}"

        self.attributes[col]  = obj
        #instance_variable_set(name_set, obj)
      end

    end




  end

  def self.table_name=(table_name)
    @table_name = table_name
    # ...
  end

  def self.table_name
    @table_name ||= name.underscore.pluralize
    # ...
  end

  def self.all



    ans = DBConnection.instance.execute(<<-SQL
    SELECT
      #{table_name}.*
    FROM
      #{table_name}
    SQL
    )
    puts ans
    parse_all(ans)
    # ...
  end

  def self.parse_all(results)
  
    results.map do |ele|

      self.new(ele)
    end

    # ...
  end

  def self.find(id)
    hash_arr = DBConnection.execute(<<-SQL)
      SELECT
        *
      FROM
        #{table_name}
      WHERE
        id = #{id}
    SQL
    if hash_arr.length < 1
      return nil
    end

    self.new(hash_arr[0])

    # ...
  end

  def initialize(params = {})
    params.each do |param, val|
      param = param.to_sym
      raise Exception.new("unknown attribute '#{param}'") unless self.class.columns.include?(param)
      self.send("#{param}=", val)
    end

    # ...
  end

  def attributes
    @attributes ||= {}

    # ...
  end

  def attribute_values

    col_names = self.class.columns
    col_names.map do |col|
      self.send(col)
    end
    # ...
  end

  def insert
    col_names = self.class.columns

    question_marks = ["?"] * col_names.length

    values = attribute_values
    #values = to_query_string(values)
    col_names = to_query_string(col_names)
    puts col_names
    question_marks = to_query_string(question_marks)
    cols = DBConnection.execute(<<-SQL, *values)
      INSERT INTO
        #{self.class.table_name}(#{col_names})
      VALUES
        (#{question_marks})
    SQL
    max_id_hash = DBConnection.execute(<<-SQL)
      SELECT
        MAX(id) AS max
      FROM
        #{self.class.table_name}

    SQL
    p max_id_hash
    self.send(:id=, max_id_hash[0]["max"])
    # ...
  end

  def to_query_string(arr)
    total = ""
    arr.each do |el|
      total += (el.to_s + " ,")
    end
    total[0..-2]
  end


  def update

    # col_names = self.class.columns
    #
    # question_marks = ["?"] * col_names.length
    #
    # values = attribute_values
    # values = to_query_string(values)
    new_line = self.class.columns
      .map { |attr| "#{attr} = ?" }.join(", ")
    #  col_names = to_query_string(col_names)
    # # puts col_names
    # question_marks = to_query_string(question_marks)

    cols = DBConnection.execute(<<-SQL, *attribute_values, id)
      UPDATE
        #{self.class.table_name}
      SET
        #{new_line}
      WHERE
        #{self.class.table_name}.id = ?

    SQL
  end
  def set_line
    total = ""
    @attributes.each do |key,val|

      total += "#{key} = #{val}, " unless key == id
    end
    total[0..-2]
  end

  def save
    id.nil? ? self.insert : self.update
  end

  # def save
  #   self.insert
  #   self.update
  #   # ...
  # end
end
