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
    #populate_tables
    puts "✅ Done seeding the database!"
  end

  def self.drop_tables
    db.execute('DROP TABLE IF EXISTS charities')
    db.execute('DROP TABLE IF EXISTS users')
  end

  def self.create_tables
    db.execute("CREATE TABLE charities (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL,
                target_group TEXT,
                information TEXT)")
    db.execute('CREATE TABLE users (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                username TEXT NOT NULL,
                password TEXT NOT NULL,
                email TEXT NOT NULL,
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
    password_hashed = BCrypt::Password.create("123")
    p "Storing hashed password (#{password_hashed}) to DB. Clear text password (123) never saved."
    db.execute('INSERT INTO users (username, password) VALUES (?, ?)', ["something", password_hashed])
  end

end
