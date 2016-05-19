# Final Project: A Text Adventure Game
# Date: 05-May-2016
# Authors: A01169701 Rodolfo Andrés Ramírez Valenzuela

require 'sinatra'
require 'sequel'
require 'json'
enable :sessions
set :bind, '0.0.0.0'
set :session_secret, 'SecretString#!$%'



# Used within the game, will have the Database in memory
DB ||= Sequel.connect("sqlite://game.db")

require_relative 'models/game'
require_relative 'models/player'
require_relative 'models/monster'
require_relative 'models/room'
require_relative 'models/movement'
require_relative 'models/states/fighting_state'
require_relative 'models/states/exploring_state'


# Main root to the game
get '/' do
  # if session[:game] == 'started'
  #   redirect '/game'
  # else
  #   erb :index
  # end
  erb:index
end

# Post of the user's infomration
post '/' do
  session[:game] = Game.new Player.new params[:name]
  session[:room_status] = {}
  redirect '/game'
end

# Begin the game
get '/game' do
  # if session[:game] != 'started'
  #   redirect '/'
  # end
  erb :game
end

get '/status' do
  get_status.to_json
end

#Method that will display the current status of the game
def get_status
  game = session[:game]
  status = Hash.new
  status[:player] = game.player.name
  status[:weapons]  = game.player.weapons.to_a
  status[:monster] = game.current_room_model.monster != nil
  status[:output] = game.state.status
  status[:state] = game.state.class.to_s
  status
end

post '/command' do
  status = Hash.new
  game = session[:game]
  command = params[:command].to_sym
  puts "EXECUTING COMMAND: #{command}"
  output = game.state.handle command
  puts output
  status = get_status
  status[:output] = output
  puts "STATUS"
  status.to_json
end

post '/shop' do
  status = get_status
  item = params[:item]
  game = session[:game]
  output = game.state.handle item
  status = get_status
  status[:output] = output
  status.to_json
end

post '/fight_monster' do
  status = get_status
  game = session[:game]
  weapon = params[:weapon].to_sym
  output = game.state.handle weapon

  status = get_status
  status[:output] = output
  status.to_json

end
