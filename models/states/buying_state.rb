# Final Project: A Text Adventure Game
# Date: 05-May-2016
# Authors: A01169701 Rodolfo Andrés Ramírez Valenzuela

require_relative 'exploring_state'


## +BuyingState+ class.
# This state represents the context where the player is trying to buy
# something to add an item to the inventory.
class BuyingState
  def initialize(game)
    @game = game
    @isBuyingFood = false
  end

  # Returns the current status for the state, i.e. request the player to buy something
  def status
    output = ""
    output = "\nYour current wealth is: #{@game.player.wealth}\n"
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

  def food_status
    output = "\nYour current wealth is: #{@game.player.wealth}\n"
    output << "\n******* Provisions & Inventory********* \n"
    output << "\nHow many stacks of food do you wish to buy ($2 ea)? \n\n"
    output
  end


  def start

  end

  def handleCheating(wealth, price, output)
    player = @game.player
    if wealth < price
      puts "You have tried to cheat me!"
      output << "\nYou have tried to cheat me! Now you will suffer!!\n"
      player.items = Hash.new
      player.food = (player.food / 4).to_i
    end
    player.wealth -= price
  end

  def handleShoppingFood(command)
    player = @game.player
    option = command.to_i
    current_item_price = 0
    output = ""
    if option == 0
      puts "Doesn't work"
      @game.state = ExploringState.new @game
      @game.state.status
      output << @game.state.status
      output
    else
      current_item_price = 2 * option
      player.food += option
      handleCheating(player.wealth, current_item_price, output)
    end
    @isBuyingFood = false
    output
  end

  # Displays the cost of the items and what items you already have
  def handle(command)
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
        @game.state.status
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
        items[:amulet] = 1
      elsif option == 6
        current_item_price = 60
        items[:suit] = 1
      end
      handleCheating(player.wealth, current_item_price, output)

      if option == 4
        @isBuyingFood = true
        output << "\n"
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
