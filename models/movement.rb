DB.create_table? :movements do
  primary_key :id

  foreign_key :room_name, :rooms, type: String
  String :north
  String :south
  String :east
  String :west
  String :up
  String :down
end

#The Movement Class specifies the valid movements the user will be able to take
# in a certain room e.g North, West, East, Up, Down, South.
class Movement < Sequel::Model
  def room
    Room[self.room_name]
  end
end
Movement.unrestrict_primary_key
