class Student
  attr_accessor :id, :name, :grade

  

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    stud = Student.new
    stud.id = row[0]
    stud.name = row[1]
    stud.grade = row[2]
    stud
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = <<-SQL
    SELECT * FROM students
    SQL
    array = []
    DB[:conn].execute(sql).each do |row|
      array<<self.new_from_db(row)
    end
    array
  end

  def self.all_students_in_grade_X(x)

    sql = <<-SQL
        SELECT * FROM students WHERE grade  = ?  
    SQL
    arr = []
    DB[:conn].execute(sql,10).each do |row|
        arr<<self.new_from_db(row)
      end
    arr

  end

  def self.first_student_in_grade_10
    sql = <<-SQL
        SELECT * FROM students WHERE grade = 10 LIMIT ? 
    SQL
    arr = []
    new_from_db(DB[:conn].execute(sql,1)[0])

  end

  def self.first_X_students_in_grade_10(num)
    sql = <<-SQL
        SELECT * FROM students WHERE grade  = 10 LIMIT ? 
    SQL
    arr = []
    DB[:conn].execute(sql,2).each do |row|
        arr<<self.new_from_db(row)
      end
    arr
  end

  def self.students_below_12th_grade
    sql = <<-SQL
        SELECT * FROM students WHERE grade < ? 
    SQL
    arr = []
    DB[:conn].execute(sql,12).each do |row|
        arr<<self.new_from_db(row)
      end
    arr
  end

  def self.all_students_in_grade_9
    sql = <<-SQL
        SELECT * FROM students WHERE grade= ? 
    SQL
    arr = []
    DB[:conn].execute(sql,9).each do |row|
        arr<<self.new_from_db(row)
      end
    arr
  end

  def self.find_by_name(name_param)
    sql = "SELECT * FROM students WHERE name = ?"
    Student.new_from_db(DB[:conn].execute(sql, name_param)[0])
  end
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
