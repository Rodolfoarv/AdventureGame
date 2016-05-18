# Final Project: A Text Adventure Game
# Date: 05-May-2016
# Authors: A01169701 Rodolfo Andrés Ramírez Valenzuela

# Main class of the game will contain the following information:
  # - Player
  # - Current Room
  # - State i.e (Explore, Fight, Shop, Win, Lose)
class Game
  # Information of the current player playing the game
  attr_accessor :player
  # Information of the current room the user is in at this moment
  attr_accessor :current_room
  # Information about the state e.g (Explore)
  attr_accessor :state

  # Initialize the game with the player's name, the current_room as the entrance
  # and set the intiial status to ExploringState which will let the user to explore
  # through the castle.
  def initialize(player)

    @player = player # Game's player

    # Current room, by default is is set to the Entrance
    @current_room = "Entrance"

    # Current state of the game, by default it is set to Exploring
    @state = ExploringState.new self
  end

  # Will display the curent infomation of the game. This is:
  # - Player's name
  # - Room description
  # - State
  def to_s
    "Player: #{player.name} \nCurrent Room: #{@current_room} \nState: #{@state}"
  end

  # Will return the current room the user is at this moment
  def current_room_model
    Room[self.current_room]
  end
end
