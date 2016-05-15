

## The +Room+ class represents a room in the game which contains a +description+
# displayed when the player enters a room and a treasure if there is any on the room
# a monster might be added to the room as well but there can never be a monster and a treasure
# in the same room, the room also contains a +movements+ which will be the available
#options that the user may handle during each room

DB.create_table? :rooms do
  foreign_key :monster_id, :monsters, type: String
  String :name, primary_key: true
  String :description
  Integer :treasure
end

class Room < Sequel::Model
  many_to_one :monster
  one_to_one :movement, key: :room_name

  #Method used to get a random room when the player uses an amulet
  def self.random
    Room.all.sample
  end
end

Room.unrestrict_primary_key
Room.set_allowed_columns :name, :description, :monster_id, :treasure
