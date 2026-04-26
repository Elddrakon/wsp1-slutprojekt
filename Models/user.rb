require_relative '../config.rb'



class User
    
  attr_accessor :user_id

  def initialize(params = {})
        @user_id = params["user_id"]
        @username = params["username"]
        @password = params["password"]
        @email = params["email"]
        @rank = params["rank"]
  end

  def self.db
    return @db if @db
    @db = SQLite3::Database.new(DB_PATH)
    @db.results_as_hash = true
    return @db
  end


  def self.add(username, password, email, rank)
    db.execute('INSERT INTO users (username, password, email, rank) VALUES (?, ?, ?, ?)', [username, password, email, rank])
  end

  def self.updaterank(username, email, rank)
    db.execute('INSERT INTO users (username, email, rank) VALUES (?, ?, ?, ?)', [username, email, rank])
  end

  def self.all()
    return db.execute("SELECT * FROM users")
  end


  def self.find_user_info(username)
    return db.execute("SELECT * FROM users WHERE username=?", username).first
  end


  def self.user_exists?(username)
    usernameexists = true
    user = db.execute("SELECT * FROM users WHERE username=?", username).first
    p user
    unless user
      usernameexists = false
    end

    return usernameexists
  end
end




