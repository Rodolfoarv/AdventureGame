# Final Project: A Text Adventure Game
# Date: 05-May-2016
# Authors: A01169701 Rodolfo Andrés Ramírez Valenzuela

require 'sinatra'
require 'sequel'
enable :sessions
# DB = Sequel.connect('sqlite://players.db') # requires sqlite3
# require ('./models/player')

get '/' do
  if session[:game] == 'started'
    redirect '/game'
  else
    erb :index
  end
  erb:index
end

post '/' do
  session[:game] = 'started'
  redirect '/game'
end

get '/game' do
  if session[:game] != 'started'
    redirect '/'
  end
  erb :game
end
