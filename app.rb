require 'debug'
require "awesome_print"
require 'bcrypt'
require 'sinatra/base'
require_relative 'config.rb'
require_relative 'Models/user.rb'
require_relative 'Models/charity.rb'

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
        @account = ""
        if session[:user_id] 
            user_object = db.execute("SELECT * FROM users WHERE user_id=?", [session[:user_id]]).first 
            user = User.new(user_object) if user_object
            @account = user.username
        end

       
        
        p @account
        erb(:"charities/index")
        #Transport.send_erb(charities/index, layoutloggedout)  
    end

    get '/charities/personalindex' do
        redirect '/users/login' unless session[:user_id]
        
        @user = session[:user_id]
        @charities = Charity.index_user(@user)
        erb(:"charities/index")
        #does not work yet!!!!
    end



    get '/charities/new' do
        redirect '/users/login' unless session[:user_id]
        erb(:"charities/new")

    end

    post '/charities' do
        new_charity_name = params["charity_name"]
        new_target_group = params["group_name"]
        new_information = params["charity_information"]
        if session[:user_id] 
            user_object = db.execute("SELECT * FROM users WHERE user_id=?", [session[:user_id]]).first 
            user = User.new(user_object) if user_object
            @account = user.username
            Charity.add(@account, new_charity_name, new_target_group, new_information)
            redirect('/charities')
        else
            redirect('/users/login')
        end
    end




    #Admin Commands///
    

    get '/admin/users/index' do
        
        @users = User.all()
        @account = ""
        if session[:user_id] 
            user_object = db.execute("SELECT * FROM users WHERE user_id=?", [session[:user_id]]).first 
            user = User.new(user_object) if user_object
            @account = user.username
            if @account == "ADMIN"
                p @account
                erb(:"users/userindex")
            else
                redirect('/users/login')
            end
        else
            redirect('/users/login')
        end

    end
    
    
    
    #Admin Commands end


    get '/users/login' do
        if session[:user_id]
            redirect(:"/charities")
        else
            erb(:"users/login")
        end
    end

    get '/users/signup' do
        if session[:user_id]
            redirect(:"/charities")  
        else
            erb(:"users/signup")
        end
    end

    get '/users/logout' do
        if session[:user_id]
            p "logged out"
            session.clear
            sleep(1)  
            redirect(:"/charities")
        else
            redirect(:"/users/login")
        end
        
    end




   
    
    
    post '/users/login' do
        recievedusername = params["username"]
        recievedpassword = params["password"] 
        p recievedpassword
        
        p recievedusername
       
        if User.user_exists?(recievedusername)
            user = User.find_user_info(recievedusername)
            if user && BCrypt::Password.new(user.password) == recievedpassword
                session[:user_id] = user.user_id
            else
                p "username is either super duper wrong or the password is duper snuper wrong!!!"
                redirect('/users/login')
            end
        
            redirect('/charities')
        else
            redirect('/users/login')
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
            p "logged user:"
            p @logged_user.username
            session[:user_id] = @logged_user.user_id
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
