require_relative "../config/environment.rb"
require 'pry'
class Student
  attr_accessor :name, :grade
  attr_reader :id

  def initialize (id = nil, name, grade)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
    sql = "CREATE TABLE IF NOT EXISTS students (
    id INTEGER PRIMARY KEY,
    name TEXT,
    grade INTEGER
    );"

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE students"
    DB[:conn].execute(sql)
  end

  def save
    if @id
      self.update
    else
      sql = <<-SQL
      INSERT INTO students (name, grade) VALUES (?,?)
      SQL
      DB[:conn].execute(sql, self.name, self.grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end
  end

  def update
      sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
      DB[:conn].execute(sql, self.name, self.grade, self.id)
  end

  def self.create(name, grade)
    sql = <<-SQL
      INSERT INTO students (name, grade) VALUES (?, ?)
    SQL
    DB[:conn].execute(sql, name, grade)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    self.new(@id, name, grade)
  end

  def self.new_from_db(db)
    self.new(db[0], db[1], db[2])
  end

  def find_by_name(db)
    binding.pry
    self.new
  end
  

end
