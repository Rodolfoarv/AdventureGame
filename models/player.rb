# Final Project: A Text Adventure Game
# Date: 05-May-2016
# Authors: A01169701 Rodolfo Andrés Ramírez Valenzuela

require 'set'

#The player class, provides all the values and initial status of the player
class Player
  # Player's name
  attr_accessor :name
  # Player's strength. Initially it takes a random value between [60 160] inclusive.
  attr_accessor :strength
  # Player's wealth. Initially it takes a random value between [30 130] inclusive.
  attr_accessor :wealth
  # Players' reserve of food. Starts in zero.
  attr_accessor :food
  # Player's movement count. It counts how many times the player has moved across rooms.
  attr_accessor :tally
  # Player's monster killed counter. How many monsters the player has killed.
  attr_accessor :monsters_killed
  # Player's items in inventory. e.g.
  #   items = {
  #     food: 20,
  #     weapons: #{:axe, :sword }
  #   }
  attr_accessor :items

  #Method that creates a new player with a given name
  def initialize(name)
    @name = name
    @strength        = 60 + rand(1..100)
    @wealth          = 30 + rand(1..100)
    @food            = 0
    @tally = 0
    @monster_tally = 0
    @items           = Hash.new
    @items[:torch]   = true
    @items[:amulet]  = true
    @items[:suit]    = true
    @items[:weapons] = Set.new [:axe, :sword]
    @inventory = Inventory.new
    @strength = 60 + rand(1..100)
    @wealth = 30 + rand(1..100)

  end

  #The toString method provides the strength wealth and unit of food the user currently has
  def to_s
    %Q{
      Your strength is #{@strength}.
      You have $#{@wealth}.
      Your provision sack holds #{@inventory.food} units of food.
    }
  end

  #Fundamental method, returns true if the user has a torch in order to advance
  def has_torch?
    self.items.has_key? :torch
  end

  #Returns the weapons that the player is carrying as a set of symbols
  def weapons
    self.items[:weapons]
  end

  #Returns the player's score
  def score
    3*@tally + 5*@strength + 2*@wealth + @food + 30*@monsters_tally
  end
end
