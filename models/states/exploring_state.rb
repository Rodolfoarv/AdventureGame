# Final Project: A Text Adventure Game
# Date: 05-May-2016
# Authors: A01169701 Rodolfo Andrés Ramírez Valenzuela

#The ExploringState class, allows to the user: fight with a monster
#see your currents status, use magic, consume food, valid movements
#pick up treasures and so on
#
require_relative 'fighting_state'
require_relative 'buying_state'

class ExploringState
  def initialize(game)
    @game = game
    @eating_food = false
  end


  # Returns the current status of the state. This includes:
  # - Player status
  # - Room description
  # - Room's treasure
  # - Room's monster
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
  def handle(command)
    puts "Doing #{command}..."
    output = ""
    if @eating_food
      puts command
      food_quantities = {:one => 1, :two => 2, :three => 3, :four => 4, :five => 5, :six => 6,
      :seven => 7, :eight => 8, :nine => 9, :ten => 10}
      units_of_food = food_quantities[command]
      food = @game.player.food
      if units_of_food > food
        output << "You do not have enough food, try again\n"
        output << consume
      else
        puts "Got here"
        @game.player.strength += 5*units_of_food
        @game.player.food -= units_of_food
        @eating_food = false
        output << "You have consumed #{units_of_food} number of foods\n"
        output << self.status
      end

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
      else
        output << self.send(method)
      end

    end
    output << "\n"
    output
  end

  # Returns the current player's score
  def tally
    player = @game.player
    output = ""
    output << "******** Your tally is:  #{player.score} ********* \n"
    output << "You have killed #{player.monsters_killed} monsters so far...\n"
    output << self.status
    output
  end

  #Allows the player to change the current state of the game to FightingState
  def fight
    monster = @game.current_room_model.monster
    player = @game.player
    return unless monster

    @game.state = FightingState.new @game

    if not player.weapons.empty?
      @game.state.status # Ask for weapon
    else
      @game.state.handle( nil ) # Start the fight directly
    end
  end

  # Moves the player to a random room using the amulet
  def magic
    output = ""
    room = Room.random
    return self.magic if room.name == "Entrance" || room.name == "Exit"
    @game.current_room = room.name
    output << "You moved to another room...\n"
    output << self.status
  end

  # Pick-up the treasure in the room if there is any
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

  # Move from one room to another
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

    @game.current_room = movements.send(direction)
    @game.player.tally += 1
    @game.player.strength -= 5

    if @game.player.strength < 1
      @game.state = DeadState.new @game
    else
      @game.state = WinnerState.new(@game) if @game.current_room == "Exit"
    end

    "You moved to another room..."
  end

  #Allows the user the probability to scape from a fight
  def run(direction)
    output = ""
    if rand > 0.7
      output << "No, you must stand and fight"
      game.state = FightingState.new game
      output << game.state.handle
      return output
    else
      move direction
    end
  end

  # Allows the player to eat food
  def consume
    @eating_food = true
    output = "\n How many units of food do you wish to consume? \nType any number between one and ten e.g one\n"
    output << "\n You have: #{@game.player.food} quantity of food\n"
    output << "\n Your strength is #{@game.player.strength} \n\n"
    output << "If you wish to return to the main screen type 0 \n"
    output << "\nWhat will you do? "
    output
  end

  # Transitions to the buying state
  def inventory
    @game.state = BuyingState.new @game
    @game.state.status
  end

  def start
    status
  end

  def fight
    puts "got here"
    monster = @game.current_room_model.monster
    player = @game.player
    return unless monster
    @game.state = FightingState.new @game
    if not player.weapons.empty?
      @game.state.status # Ask for weapon
    else
      @game.state.handle( nil ) # Start the fight without any weapon
    end
  end

end
