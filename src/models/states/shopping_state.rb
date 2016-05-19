# Final Project: A Text Adventure Game
# Date: 05-May-2016
# Authors: A01169701 Rodolfo Andrés Ramírez Valenzuela

require_relative 'exploring_state'

# This state represents when the user is inside the inventory, this way the user
# will be able to purchase items and use them in the adventure ahead.
#The following items that may be purchased are:
# - Flaming Torch
# - Axe
# - Sword
# - Food
# - Magic Amulet
# - Suit of Armor
class ShoppingState

  #Method that initializes the State, contains the game the user is currently in
  #and an attribute isBuyingFood in order to display another menu to purchase food quantity.
  def initialize(game)
    @game = game #Current game
    @isBuyingFood = false #If it should display the optional menu
  end

  #Method that returns the current status, this will display the menu
  def status
    output = ""
    output = "\nYour current wealth is: #{@game.player.wealth}\n"
    output << "\n Your current number of food stacks is: #{@game.player.food}\n"
    output << "\n******* Provisions & Inventory********* \n"
    output << "\nWelcome to the store! May I offer you something? \n\n1- Flamming Torch ($15)\n"
    output << "2 - Axe ($10) \n"
    output << "3 - Sword ($20)\n"
    output << "4 - Food ($2 per unit)\n"
    output << "5 - Magic Amulet ($30)\n"
    output << "6 - Suit of Armor ($50)\n"
    output << "0 - To continue adventure\n"
    output
  end

  #Method that displays the optional menu for buying food
  def food_status
    output = "\nYour current wealth is: #{@game.player.wealth}\n"
    output << "\n******* Provisions & Inventory********* \n"
    output << "\nHow many stacks of food do you wish to buy ($2 ea)? \n\n"
    output
  end

  #Method that displays the current status
  def start
    self.status
  end

  #Method that handles the cheating if the user tries to purchase something
  #and has no money
  def handleCheating(wealth, price, output)
    player = @game.player
    if wealth < price
      output << "\nYou have tried to cheat me! Now you will suffer!!\n"
      player.items = Hash.new
      player.food = (player.food / 4).to_i
    end
    player.wealth -= price
  end

  #Method that handles the food shopping, i.e the quantity of food the user wants to buy
  def handleShoppingFood(command)

    player = @game.player
    option = command.to_i
    current_item_price = 0
    output = ""
    if option == 0
      @game.state = ExploringState.new @game
      output << "Back to exploring!"
      output << @game.state.status
    else
      current_item_price = 2 * option
      player.food += option
      handleCheating(player.wealth, current_item_price, output)
      output << @game.state.status
    end
    @isBuyingFood = false
    output
  end

  # Method that will be used to verify the commands in the input line
  def handle(command)
    puts "got here"
    puts command
    if command == :start
      return self.status
    end

    if @isBuyingFood
      handleShoppingFood(command)
    else
      player = @game.player
      output = "Thanks for visiting the shop! Stop by again sometime"
      items = @game.player.items
      current_item_price = 0

      option = command.to_i
      if option == 0
        @game.state = ExploringState.new @game
      elsif option == 1
        current_item_price = 15
        items[:torch] = 1
      elsif option == 2
        current_item_price = 10
        items[:weapons] << :axe
      elsif option == 3
        current_item_price = 20
        items[:weapons] << :sword
      elsif option == 4

      elsif option == 5
        current_item_price = 30
        items[:amulet] = true
      elsif option == 6
        current_item_price = 60
        items[:suit] = 1

      end
      handleCheating(player.wealth, current_item_price, output)

      if option == 4
        @isBuyingFood = true
        output = ""
        output << food_status
        output
      else
        output << "\n"
        output << @game.state.status
      end

      output
    end
  end
end
