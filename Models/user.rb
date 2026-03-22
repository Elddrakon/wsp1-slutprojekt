#Place where all of the shit happens!!!
require 'debug'
require "awesome_print"
require 'bcrypt'
setup_development_features(self)

  # Funktion för att prata med databasen
  # Exempel på användning: db.execute('SELECT * FROM fruits')
  def db
    return @db if @db
    @db = SQLite3::Database.new(DB_PATH)
    @db.results_as_hash = true

    return @db
  end
#
#
#
#
#
#
#
#
#
#
#
#
#
#
class User
  def self.all()
    return db.execute("SELECT * FROM users")
  end
  def self.compare(params, value)
  end
  def self.user_check(username)
    usernamemissing = false
    user = db.execute("SELECT * FROM users WHERE username=?", username).first
    unless user
      usernamemissing = true
    end
    return usernamemissing
  end
  def login(givenusername, givenpassword)
    
  end
  def signup()
        
  end
end


