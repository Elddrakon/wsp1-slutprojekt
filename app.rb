require 'debug'
require "awesome_print"

class App < Sinatra::Base

    setup_development_features(self)

    # Funktion för att prata med databasen
    # Exempel på användning: db.execute('SELECT * FROM fruits')
    def db
      return @db if @db
      @db = SQLite3::Database.new(DB_PATH)
      @db.results_as_hash = true

      return @db
    end

    # Routen /
    get '/' do
        redirect('/charities')
    end

    get '/charities' do
        erb(:"charities/index", layout: :"layoutloggedout")  
    end

    get '/charities/login' do
        erb(:"charities/login", layout: :"layoutloggedout")
    end

    post '/charities/login' do
        todos = db.execute('SELECT * FROM users WHERE ')
          
    end
    

    #get '/user/charities'
end
