require_relative "../config/environment.rb"
require 'pry'
class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]  
  attr_accessor :grade, :id, :name

  @@all = []

  def self.all
  	@@all 
  end

  def self.db 
  	DB[:conn]
  end

  def self.create_table
  	sql = <<-SQL 
  	CREATE TABLE IF NOT EXISTS students (
  		id INTEGER PRIMARY KEY,
  		name TEXT,
  		grade INTEGER)
  	SQL

  	db.execute(sql)
  end
 
	def self.drop_table
  	sql = <<-SQL 
  	DROP TABLE students;
  	SQL

  	db.execute(sql)
  end

  def self.create(name, grade)
  	student = Student.new(name, grade)
  	student.save
  end

  def self.new_from_db(row)
    id = row[0]
    name = row[1]
    grade = row[2]
    self.new(id, name, grade)
  end

  def self.find_by_name(name)
  	sql = <<-SQL
  	select * from students where name = ?
  	limit 1;
  	SQL

		student = self.new_from_db(db.execute(sql, name).flatten)
  end

  def initialize(id = nil, name, grade)
  	@name = name
  	@grade = grade
  	@id = id
  	@@all << self
  end

  def save
  	if self.id
  		self.update
  	else
  		self.store
  	end
  end


  def store
  	sql = <<-SQL 
  	INSERT INTO students (name, grade) VALUES (?, ?);
  	SQL

  	self.class.db.execute(sql, self.name, self.grade)

  	self.id = self.class.db.last_insert_row_id
  	self
  end

  def update
  	sql = <<-SQL 
  	UPDATE students SET name = ?, grade = ?
  	where id = ?;
  	SQL

  	self.class.db.execute(sql, self.name, self.grade, self.id)
  	self
  end

end













