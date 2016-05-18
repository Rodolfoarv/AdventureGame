# Final Project: A Text Adventure Game
# Date: 05-May-2016
# Authors: A01169701 Rodolfo Andrés Ramírez Valenzuela


require_relative 'fighting_state'
require_relative 'shopping_state'
require_relative 'win_state'
require_relative 'lose_state'

#The ExploringState class, allows the user to explore through the castle
#The use is able to check the current status of the game, use magic, consume food
#and every action it is permited to. Also this class is responsible for the main
#loop on the Game
class ExploringState

  #Method that initializes the state with the current game
  def initialize(game)
    # game information
    @game = game
    # verifies if the user is buying food
    @eating_food = false
    # handle the running, in this state no other action is permitted beside moving
    @is_moving = false
  end


  #Method that returns the current status.
  #It will display on the user input the following information:
  # - Player's status
  # - Room descrption
  # - Room treasure (if exists)
  # - Room monster (if exists)
  def status
    has_torch = @game.player.has_torch?
    return "You can't see anything, you must purchase a torch\n" unless has_torch

    output = StringIO.new
    output << @game.player.to_s
    output << "\n"

    output << "#{@game.current_room_model.description}\n"

    treasure = @game.current_room_model.treasure
    output << "\nThere is treasure here worth $#{treasure}.\n" if treasure && treasure > 0

    monster = @game.current_room_model.monster
    if monster
      output << "\nDANGER... THERE IS A MONSTER HERE....\n\n"
      output << "#{@game.current_room_model.monster}\n\n"
    end

    if @game.current_room_model.name != "Exit"
      output << "\nWhat do you want to do? "
    end

    output.string
  end

  # Handles a command for this state.
  # +command+ must be a symbol
  # Possible commands:
  # - :north : Moves you to north
  # - :south : Moves you to south
  # - :east : Moves you to east
  # - :west : Moves you to west
  # - :up : Moves you to up
  # - :down : Moves you to down
  # - :tally : Shows you the current score and number of monsters killed
  # - :run : Tries to run from the current room
  # - :magic : Uses the player's Amulet to randomly move to another room
  # - :pick_up : Picks the room's treasure if there is any
  # - :fight : Fights with the monster in the room
  # - :consume : Eats food to gain strength
  # - :inventory : Will move to the ShoppingState and display the inventory information
  def handle(command)

    output = ""
    if @eating_food
      food_quantities = {:zero => 0, :one => 1, :two => 2, :three => 3, :four => 4, :five => 5, :six => 6,
      :seven => 7, :eight => 8, :nine => 9, :ten => 10}
      units_of_food = food_quantities[command]
      food = @game.player.food
      if units_of_food > food
        output << "\n*** You do not have enough food, try again ***\n"
      else
        @game.player.strength += 5*units_of_food
        @game.player.food -= units_of_food
        output << "You have consumed #{units_of_food} number of foods\n"
      end
      @eating_food = false
      output << self.status
    else
      method = command
      case command
      when :north then method = :move
      when :south then method = :move
      when :east  then method = :move
      when :west  then method = :move
      when :up    then method = :move
      when :down  then method = :move
      end

      output = ""
      if method == :move
        output << self.send(method, command)
        output << self.status
        @is_moving = false
      else
        if @is_moving
          output << "Don't waste time on that! You must run!!! \n"
          output << @game.current_room_model.description
        else
          output << self.send(method)
        end

      end

    end
    output << "\n"
    output
  end

  # Method that displays the current score of the game, the user is able to request this
  # at anytime
  def tally
    player = @game.player
    output = ""
    output << "******** Your tally is:  #{player.score} ********* \n"
    output << "You have killed #{player.monsters_killed} monsters so far...\n"
    output << self.status
    output
  end


  # Method that will move the user to another random room
  def magic
    output = ""
    room = Room.random
    return self.magic if room.name == "Entrance" || room.name == "Exit"
    @game.current_room = room.name
    output << "You moved to another room...\n"
    output << self.status
  end

  # Method that is used to pick_up a treasure
  def pick_up
    output = ""
    treasure = @game.current_room_model.treasure
    has_torch = @game.player.has_torch?
    return "There is no treasure to pick up\n" unless treasure && treasure > 0
    return "You cannot see anything, you must buy a torch\n" unless has_torch
    @game.player.wealth += treasure
    @game.current_room_model.update(:treasure => 0) #Update the treasure to 0
    output << "You picked-up gems worth $#{treasure}\n"
    output << self.status

    return output
  end

  # Method that will validate the movement of the player, it will only
  # be able to move to the rooms the user is able to.
  def move(direction)
    movements = @game.current_room_model.movement
    monster = @game.current_room_model.monster
    has_torch = @game.player.has_torch?

    return "You must buy a torch to continue on your adventure\n" unless has_torch

    if direction == :north and not movements.north
      return "No exit that way"
    elsif direction == :south and not movements.south
      return "There is no exit south"
    elsif direction == :east and not movements.east
      return "You cannot go in that direction"
    elsif direction == :west and not movements.west
      return "You cannot move through solid stone"
    elsif direction == :up and not movements.up
      return "You cannot go up this floor"
    elsif direction == :down and not movements.down
      return "You cannot go down this floor"
    end

    return "Monster shouts: YOU SHALL NOT PASS!!" if monster && rand < 0.1


    @game.player.tally += 1
    @game.player.strength -= 5

    if @game.player.strength < 1
      @game.state = DeadState.new @game
      return @game.state.status
    else
      @game.state = WinnerState.new(@game) if @game.current_room == "Exit"
    end
        @game.current_room = movements.send(direction)

    "You moved to another room..."
  end

  #Method that allows the user to run from the fight
  def run
    return "You can't run, there is no monster here #{self.status}" unless @game.current_room_model.monster
    has_torch = @game.player.has_torch?
    return "You can't see anything, you must purchase a torch\n" unless has_torch
    player = @game.player
    output = ""
    if rand > 0.7
      output << "No, you must stand and fight\n Watch out Hero!! The monster is coming to you! \n"
      @game.state = FightingState.new @game
      if not player.weapons.empty?
        output << @game.state.status # Ask for weapon
      else
        output << @game.state.handle( nil ) # Start the fight without any weapon
      end
    else
      output << "This is your opportunity!!! You have the chance to run \n"
      output << "Where shall you run?\n"
      output << "#{@game.current_room_model.description}"
      @is_moving = true
      output
    end

  end

  # Method that allows the player to eat food
  def consume
    @eating_food = true
    output = "\n How many units of food do you wish to consume? \nType any number between one and ten as a word e.g one\n"
    output << "\n You have: #{@game.player.food} quantity of food\n"
    output << "\n Your strength is #{@game.player.strength} \n\n"
    output << "\nWhat will you do? "
    output
  end

  # Method that handles the transition to the ShoppingState
  def inventory
    @game.state = ShoppingState.new @game
    @game.state.status
  end

  # Method used to display the current status of the game when the user enters the terminal
  def start
    status
  end

  #Method used to handle the fight between a monster and the user.
  def fight
    has_torch = @game.player.has_torch?
    return "You can't see anything, you must purchase a torch\n" unless has_torch
    monster = @game.current_room_model.monster
    player = @game.player
    return "There is no monster in this room \n #{self.status}" unless monster
    @game.state = FightingState.new @game
    if not player.weapons.empty?
      @game.state.status # Ask for weapon
    else
      @game.state.handle( nil ) # Start the fight without any weapon
    end
  end

end
