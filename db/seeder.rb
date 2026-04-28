require 'sqlite3'
require_relative '../config'
require 'bcrypt'

class Seeder

  def self.seed!
    puts "Using db file: #{DB_PATH}"
    puts "🧹 Dropping old tables..."
    drop_tables
    puts "🧱 Creating tables..."
    create_tables
    #puts "🍎 Populating tables..."
    populate_tables
    puts "✅ Done seeding the database!"
  end

  def self.drop_tables
    db.execute('DROP TABLE IF EXISTS charities')
    db.execute('DROP TABLE IF EXISTS users')
  end

  def self.create_tables
    db.execute("CREATE TABLE charities (
                charity_id INTEGER PRIMARY KEY AUTOINCREMENT,
                username TEXT NOT NULL,
                name TEXT NOT NULL,
                target_group TEXT,
                information TEXT,
                user_id INTEGER,
                FOREIGN KEY (user_id) REFERENCES users(user_id))")
    db.execute('CREATE TABLE users (
                user_id INTEGER PRIMARY KEY AUTOINCREMENT,
                username TEXT NOT NULL,
                password TEXT NOT NULL,
                email TEXT,
                rank INTEGER)')
  end

  
  private

  def self.db
    @db ||= begin
      db = SQLite3::Database.new(DB_PATH)
      db.results_as_hash = true
      db
    end
  end

  def self.populate_tables
    #Users database populate: Start
    password_hashed = BCrypt::Password.create("123")
    username = "Adam"
    email = "adam07.clarke@gmail.com"
    rank = 0
    p "Storing hashed password (#{password_hashed}) to DB. Clear text password (123) never saved."
    #example 1:
    db.execute('INSERT INTO users (username, password, email, rank) VALUES (? ,?, ?, ?)', [username, password_hashed, email, rank])
    #example 2:
    password_hashed_erik = BCrypt::Password.create("12345")
    db.execute('INSERT INTO users (username, password, email, rank) VALUES (?, ?, ?, ?)', ["Erik", password_hashed_erik, "erik09.clarke@gmail.com", 0 ])

    #Admin in users database: Start
    
    password_hashed_ADMIN = BCrypt::Password.create("6767")
    db.execute('INSERT INTO users (username, password, rank) VALUES (?, ?, ?)', ["ADMIN", password_hashed_ADMIN, 100])

    #Users database populate: End
    
    #Charitys database populate: Start
    charity_username = "Erik"
    name = "Charity against cancer"
    target_group = "Childreen"
    information = "A charity that raises money to fight for childreen with cancer!!!"
    #example 1: 
    db.execute('INSERT INTO charities (username, name, target_group, information) VALUES (?, ?, ?, ?)', [charity_username, name, target_group, information])
    #Charitys database populate: End
  end

end
