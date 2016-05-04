# Final Project: A Text Adventure Game
# Date: 05-May-2016
# Authors: A01169701 Rodolfo Andrés Ramírez Valenzuela

# DB.create_table? :players do
#   primary_key         :id
#   String              :name
#   Fixnum              :strength
#   Fixnum              :wealth
#   Fixnum              :monster_tally
#
# end

require 'inventory'

class Player

  attr_accessor :strength, :wealth, :inventory, :strength, :tally, :monster_tally

  def initialize(name)
    @name = name
    @inventory = Inventory.new
    @strength = 60 + rand(1..100)
    @wealth = 30 + rand(1..100)
    @tally = 0
    @monster_tally = 0
  end

  def to_s
    %Q{
      Your strength is #{@strength}.
      You have $#{@wealth}.
      Your provision sack holds #{@inventory.food} units of food.
    }
  end

end

pl = Player.new("Rodolfo")
print pl
