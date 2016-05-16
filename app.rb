# Final Project: A Text Adventure Game
# Date: 05-May-2016
# Authors: A01169701 Rodolfo Andrés Ramírez Valenzuela

require 'sinatra'
require 'sequel'
require 'json'
enable :sessions
set :bind, '0.0.0.0'
set :session_secret, 'SecretString#!$%'

DB ||= Sequel.connect("sqlite://game.db") # in memory

require_relative 'models/game'
require_relative 'models/player'
require_relative 'models/monster'
require_relative 'models/room'
require_relative 'models/movement'
require_relative 'models/states/fighting_state'
require_relative 'models/states/exploring_state'


get '/' do
  # if session[:game] == 'started'
  #   redirect '/game'
  # else
  #   erb :index
  # end
  erb:index
end

post '/' do
  session[:game] = Game.new Player.new params[:name]
  redirect '/game'
end

get '/game' do
  # if session[:game] != 'started'
  #   redirect '/'
  # end
  p session[:game]
  erb :game
end

get '/status' do
  get_status.to_json
end

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
  p "Params"
  p params
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
