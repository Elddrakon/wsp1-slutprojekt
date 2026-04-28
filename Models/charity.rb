require 'debug'
require "awesome_print"
require 'bcrypt'


# Here are all the functions connected directly to the charities:
# 
#
#
class Charity
  def self.db
    return @db if @db
    @db = SQLite3::Database.new(DB_PATH)
    @db.results_as_hash = true
    return @db
  end

  def self.add(new_username, new_charity_name, new_target_group, new_information)
    db.execute('INSERT INTO charities(username, name, target_group, information) VALUES (?, ?, ?, ?)', [new_username, new_charity_name, new_target_group, new_information])
  end

  def self.index()
    return db.execute('SELECT * FROM charities')
  end

  def self.index_user(user_id)
    return db.execute('SELECT * FROM charities WHERE user_id=?', user_id)
  end
end