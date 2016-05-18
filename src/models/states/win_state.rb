# Final Project: A Text Adventure Game
# Date: 05-May-2016
# Authors: A01169701 Rodolfo Andrés Ramírez Valenzuela

# Class that represents the Winning State, when the user reaches the exit.
class WinnerState

  # Initializes the state with the current status of teh game.
  def initialize(game)
    #current game
    @game = game
  end

  # Handle the winning, will display into the user terminal the winning response.
  def handle
    output = ""
    player = @game.player
    output << "You won!! you have scaped with life from the castle!!! "
    output << "WELL DONE!!"
    output << "Your final score is => #{player.score}\n"
    output
  end
end
