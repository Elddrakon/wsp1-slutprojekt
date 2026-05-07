require_relative '../config.rb'

class User
    
  attr_accessor :user_id
  attr_accessor :username
  attr_accessor :password
  attr_accessor :email
  attr_accessor :rank

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

  def self.add_rank(donation_amount, user_id)
    old_rank = db.execute('SELECT rank FROM users WHERE user_id=?', [user_id])

    rankvalue = old_rank[0]["rank"]
    new_rank_value = rankvalue + donation_amount.to_i
    db.execute('UPDATE users SET rank=? WHERE user_id=?', [new_rank_value, user_id])
  end

  def self.get_rank(user_rank_value)
    
    if user_rank_value >= 1_000_000
      rank = "Elite"
    elsif user_rank_value >= 250_000
      rank = "Diamond"
    elsif user_rank_value >= 10_0000
      rank = "Gold"
    elsif user_rank_value >= 1_000
      rank = "Silver"
    elsif user_rank_value >= 100
      rank = "Bronze"
    else
      rank = "Broke ahhhh boy"
    end
    return rank

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

  def self.find_user_info_usingUser_id(user_id)
    user_object = db.execute("SELECT * FROM users WHERE user_id=?", [user_id]).first 
    user = User.new(user_object) if user_object
    return user
  end

  def self.encrypt_password(password)
    return BCrypt::Password.create(password)
  end


  def self.find_user_info(username)
    user_object = db.execute("SELECT * FROM users WHERE username=?", username).first
    return user_object ? new(user_object) : nil
  end


  def self.user_exists?(username)
    usernameexists = true
    user = db.execute("SELECT * FROM users WHERE username=?", username).first
    unless user
      usernameexists = false
    end

    return usernameexists
  end
end




