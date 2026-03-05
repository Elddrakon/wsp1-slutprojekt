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

    get '/charities/singup' do
        erb(:"charities/signup", layout: :"layoutloggedout")
    end




    post '/charities/login' do
        @usernamelock = false
        @passwordlock = false
        usernamemissing = false
        newusername = params["username"]
        newpassword_hashed = params["password"]
        p newusername
        user = db.execute("SELECT * FROM users WHERE username=?", newusername).first
        
        unless user
            ap "/login : Invalid username."
            status 401
            
            usernamemissing = true
        end
        if usernamemissing != true
            p user
            oldpassword_hashed = user["password"]
            p newpassword_hashed
            bcrypt_db_password = BCrypt::Password.new(newpassword_hashed)
            p bcrypt_db_password

            @logins = db.execute("SELECT * FROM users WHERE username=?", newusername)
            if @logins == true then
                @usernamelock = true
            end

            if db.execute("SELECT * FROM users WHERE password=?", bcrypt_db_password) && oldpassword_hashed == bcrypt_db_password
                @passwordlock = true  
            end
            if @usernamelock || @passwordlock == false
                ap "something bad"
                erb(:"charities/signup", layout: :"layoutloggedout")
            else
                ap "something good"
                redirect('/loggedincharities')
            end        
        else
            erb(:"charities/signup", layout: :"layoutloggedout")
        end
        
    end
    
    post '/charities/signup' do
        newusername = params["username"]
        newpassword_hashed = params["password"] 
        p newpassword_hashed
        bcryptPassword = BCrypt::Password.new(newpassword_hashed)
        newemail = params["email"]
        p newusername
        p newemail
        if db.execute("SELECT * FROM users WHERE username=?", newusername)
            db.execute('INSERT INTO users (username, password, email) VALUES (? ,? ,?)', [newusername, bcryptPassword, newemail])
            redirect('/loggedincharities')
        else
            erb(:"charities/signup")
            p "something went wrong!!!"
        end
    end



    #get '/user/charities'
    get '/loggedincharities' do
        erb(:"loggedincharities/index_lg", layout: :"layoutloggedin") 
        ap "switched layout to logged_in version!"
    end
end
