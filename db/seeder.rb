require 'sqlite3'
require_relative '../config'
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
                password INTEGER NOT NULL,
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

end
