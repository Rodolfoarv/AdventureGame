# Final Project: A Text Adventure Game
# Date: 05-May-2016
# Authors: A01169701 Rodolfo Andrés Ramírez Valenzuela

# Class that represents the State when the user loses the game
class DeadState

  # Initializes the state with the current status of the game. i.e, dead.
  def initialize(game)
    @game = game
  end

  # Displays the information of GAME OVER with the player's score.
  def status
    output = ""
    output << "You have died.... GAME OVER"
    output << score
    output << "To restart the game, go to the main menu"
    output
  end

  # Returns the current player's score
  def score
    player = @game.player
    output = ""
    output << "******** Your tally is:  #{player.score} ********* \n"
    output << "You have killed #{player.monsters_killed} monsters so far...\n"
    output
  end

  # Method that will handle the game over.
  def handle(command)
    self.status
  end


end
