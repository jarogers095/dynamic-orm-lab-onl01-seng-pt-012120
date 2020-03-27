require_relative "../config/environment.rb"
require 'active_support/inflector'

class InteractiveRecord
  def initialize(options={})
    options.each do |k, v|
      self.instance_variable_set(":#{k}", v)
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
end