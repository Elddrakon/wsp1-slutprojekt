require 'debug'
require "awesome_print"
require 'bcrypt'
require 'sinatra/base'
require_relative 'config.rb'
require_relative 'Models/user.rb'
require_relative 'Models/charities.rb'

class App < Sinatra::Base
    enable :sessions
    use Rack::Session::Cookie, 
        key: 'rack.session',
        path: '/',
        secret: "cf22c9d6061b3e067155e59d775d4406c92b6afc4aaff0a4131e9165eb2d492b597ace501a3df36043ecba99ae29474acac0cbd8c75fb5f46503b3e90d8b8159"

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
        @charities = Charity.index()
        @users = User.all()
        @account = @logged_user
        erb(:"charities/index")
        #Transport.send_erb(charities/index, layoutloggedout)  
    end


    get '/charities/new' do
        erb(:"charities/new")

    end



    get '/users/login' do
        erb(:"users/login")
    end

    get '/users/signup' do
        p 123
        erb(:"users/signup")
    end

    get '/users/logout' do
        p "logged out"
        sleep(1)  
        erb(:"charities")
    end




   
    
    
    post '/users/login' do
        recievedusername = params["username"]
        recievedpassword_hashed = params["password"]

        if User.find_user_info(recievedusername) == true
            @user = User.find_user_info(recievedusername)
            oldpassword_hashed = @user

        end
    end
    
    post '/users/signup' do
        recievedusername = params["username"]
        recievedpassword_hashed = params["password"] 
        p recievedpassword_hashed
        bcryptPassword = BCrypt::Password.create(recievedpassword_hashed)
        recievedemail = params["email"]
        p recievedusername
        p recievedemail
        if not User.user_exists?(recievedusername)
            User.add(recievedusername, bcryptPassword, recievedemail, 0)
            @logged_user = User.find_user_info(recievedusername)
            redirect('/charities')
        else
            erb(:"users/signup")
            p "something went wrong or username is already in use!!!"
            sleep(1)
            erb(:"users/signup")
        end
    end



    #get '/user/charities'
    
end
