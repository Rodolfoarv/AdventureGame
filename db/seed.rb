require 'csv'
require 'sequel'
DB = Sequel.connect("sqlite://game.db") # in memory

require_relative '../models/monster'
require_relative '../models/room'
require_relative '../models/movement'


# Clean the database
Room.dataset.delete
Movement.dataset.delete
Monster.dataset.delete

# Read the monsters stored in a CSV
monsters_csv = File.join File.dirname(__FILE__), "monsters.csv"
monsters     = CSV.read(monsters_csv)
monsters.shift

# Read the rooms stored in CSV
roomscsv = File.join File.dirname(__FILE__), "rooms.csv"
rooms = CSV.read(roomscsv)
rooms.shift

# Read movements stored in CSV
movementscsv = File.join File.dirname(__FILE__), "movements.csv"
movements = CSV.read(movementscsv)
movements.shift

puts "Wait until we set up the database...."
# Create models
monsters.each do |r|
  Monster.create(name:     r[0],
                 ferocity: r[1].to_i)
end
puts "#{movements.length} monsters created."

rooms.each do |r|
  Room.create(name:        r[0],
              description: r[1],
              monster_id:  r[2],
              treasure:    r[3].to_i)
end
puts "#{rooms.length} rooms created."

movements.each do |r|
  Movement.create(room_name: r[0],
                  north:     r[1],
                  south:     r[2],
                  east:      r[3],
                  west:      r[4],
                  up:        r[5],
                  down:      r[6])
end
puts "#{movements.length} movements created."
