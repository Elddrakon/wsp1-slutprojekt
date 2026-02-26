require 'debug'
require "awesome_print"
require 'bcrypt'

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
        @usernamelock = false
        @passwordlock = false
        newusername = params["username"]
        newpassword_hashed = params["password"]
        p newusername
        user = db.execute("SELECT * FROM users WHERE username=?", newusername).first
        
        unless user
            ap "/login : Invalid username."
            status 401
        end

        p user
        oldpassword_hashed = user["password"].to_s

        bcrypt_db_password = BCrypt::Password.new(oldpassword_hashed)
        p bcrypt_db_password

        @logins = db.execute("SELECT * FROM users WHERE users=?", newusername)
        if logins == true then
            @usernamelock = true
        end

        if db.execute("SELECT * FROM users WHERE password_hash=?", bcrypt_db_password)
            @passwordlock = true  
        end
        if @usernamelock || @passwordlock == false
            ap "something bad"
        else
            ap "something good"
            #redirect('/')
        end
    end
    

    #get '/user/charities'
end
