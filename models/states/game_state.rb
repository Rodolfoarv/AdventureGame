# Final Project: A Text Adventure Game
# Date: 05-May-2016
# Authors: A01169701 Rodolfo Andrés Ramírez Valenzuela


#GameState class, provides the state of the game
class GameState
  attr_reader :game

  def initialize(game)
    @game = game
  end
end
