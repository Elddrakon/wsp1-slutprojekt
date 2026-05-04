require 'debug'
require "awesome_print"
require 'bcrypt'
require_relative '../config.rb'

class Donate
  
  def self.db
    return @db if @db
    @db = SQLite3::Database.new(DB_PATH)
    @db.results_as_hash = true
    return @db
  end

  def self.all()
    return db.execute('SELECT * FROM donations')
  end

  def self.view_user_donations(user_id)
    return db.execute('SELECT * FROM donations WHERE user_id=?', user_id)
  end

  def self.donate(donated_amount, donated_charity, user_id)
    db.execute('INSERT INTO donations(donation_amount, donated_charity, user_id) VALUES (?, ?, ?)', [donated_amount, donated_charity, user_id])
  end

end