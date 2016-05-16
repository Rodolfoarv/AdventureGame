# Final Project: A Text Adventure Game
# Date: 05-May-2016
# Authors: A01169701 Rodolfo Andrés Ramírez Valenzuela

class Game
  attr_accessor :player, :current_room, :state

  def initialize(player)
    @player = player
    @current_room = "Entrance"
    @state = ExploringState.new self
  end

  def to_s
    "Player: #{player.name} \nCurrent Room: #{@current_room} \nState: #{@state}"
  end


  def current_room_model
    Room[self.current_room]
  end
end
