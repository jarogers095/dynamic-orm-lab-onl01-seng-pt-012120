require_relative "../config/environment.rb"
require 'active_support/inflector'

class InteractiveRecord
  def self.table_name()
    self.to_s.downcase.pluralize
  end
  
  def self.column_names()
    sql = DB[:conn].prepare("PRAGMA table_info( ? );")
    sql.bind_param(1, table_name)
    table_info = 
    column_names = []
    
    table_info.each do |row|
      column_names << row["name"]
    end
    
    column_names.compact
  end
end