require_relative "../config/environment.rb"
require 'active_support/inflector'

class InteractiveRecord
  def initialize(options={})
    options.each do |k, v|
      self.send("#{k}=", v)
    end
  end
  
  def self.table_name()
    self.to_s.downcase.pluralize
  end
  
  def self.column_names()
    sql = "PRAGMA table_info( '#{table_name}');"
    table_info = DB[:conn].execute(sql)
    column_names = []
    
    table_info.each do |row|
      column_names << row["name"]
    end
    
    column_names.compact
  end
  
  def table_name_for_insert()
    self.class.table_name
  end
  
  def col_names_for_insert()
    self.class.column_names.delete_if{|col| col == "id"}.join(", ")
  end
  
  def values_for_insert()
    columns = self.class.column_names.delete_if{|col| col == "id"} 
    values = columns.map do |cols|
      "'#{self.send(cols)}'"
    end
    values.join(", ")
  end
  
  def save()
    sql = "INSERT INTO #{table_name_for_insert} (#{col_names_for_insert}) VALUES (#{values_for_insert});"
    DB[:conn].execute(sql)
  end
end