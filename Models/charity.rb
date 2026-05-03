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
    user = db.get_first_row('SELECT user_id FROM users WHERE username = ?', [new_username])
    user_id = user['user_id']

    db.execute('INSERT INTO charities(username, name, target_group, information, user_id) VALUES (?, ?, ?, ?, ?)', [new_username, new_charity_name, new_target_group, new_information, user_id])
  end

  def self.find_charity(charity_id)
    db.execute('SELECT * FROM charities WHERE charity_id=?', charity_id).first
  end

  def self.update_charity(name, target_group, information, charity_id)
    db.execute('UPDATE charities SET name=?, target_group=?, information=? WHERE charity_id=?', [name, target_group, information, charity_id])
  end


  def self.destroy(charity_id)
    db.execute('DELETE FROM charities WHERE charity_id=?', charity_id)
  end

  def self.index()
    return db.execute('SELECT * FROM charities')
  end

  def self.index_user(user_id)
    return db.execute('SELECT * FROM charities WHERE user_id=?', user_id)
  end
end