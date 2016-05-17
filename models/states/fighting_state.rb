# Final Project: A Text Adventure Game
# Date: 05-May-2016
# Authors: A01169701 Rodolfo Andrés Ramírez Valenzuela

#FightingState class, provides all the logic for handling a battle

class FightingState
  def initialize(game)
    @game = game
  end

  # Returns the current status of the state, i.e. if the game is
  # waiting fo the player to chose a weapon to fight with.
  def status

    monster = @game.current_room_model.monster
    return unless monster

    weapons = @game.player.weapons

    output = "With a ferocious sight the Wild #{monster.name} wants to fight! \n"
    output << "Be careful it's ferocity level is #{monster.ferocity}\n"


    weapons.each_with_index do |weapon, i|
      output << "#{i + 1} - #{weapon}\n"
    end

    output
  end

  # Provides all the logic for fighting
  def handle(weapon)
    weapon = weapon.to_sym if weapon
    output = ""
    return "No monster here\n" unless @game.current_room_model.monster
    # Get the input for the user
    player = @game.player
    items = @game.player.items
    weapons = items[:weapons]
    # Omitted double ask for key line 740
    new_ferocity = @game.current_room_model.monster.ferocity

    if weapons.include? weapon
      if weapon == :axe
          output << "You will have fight with your axe! On guard Hero!!\n"
          new_ferocity = 4 * (new_ferocity / 5).to_i
          output << "\nThe ferocity of the monster is now: #{new_ferocity}\n"

      else
        output << "You will have fight with your sword! On guard Hero!!\n"
        new_ferocity = 3 * (new_ferocity / 4).to_i
        output << "\nThe ferocity of the monster is now: #{new_ferocity}\n"

      end
    else
      output << "\nYou do not have that weapon\n"
      output << "You must fight with bare hands.\n"
      new_ferocity = (new_ferocity + new_ferocity / 5).to_i
    end

    if items.has_key? :suit
      output << "Your armor increases your chance of success.\n"
      new_ferocity = 3 * (@game.current_room_model.monster.ferocity / 4).to_i
      output << "\nThe ferocity of the monster is now: #{new_ferocity}\n"
    end


    # has_sword = weapons.include? :sword
    # has_axe = weapons.include? :axe
    # has_both = has_axe || has_sword
    #
    # if not has_both
    #   output << "You must fight with bare hands.\n"
    #   new_ferocity = (new_ferocity + new_ferocity / 5).to_i
    #   output << "\nThe ferocity of the monster is now: #{new_ferocity}"
    # end


      # has_just_sword = has_sword && !has_axe
      #
      # if has_just_sword
      #   output << "You must fight with your sword.\n"
      #   new_ferocity = 3 * (new_ferocity / 4).to_i
      # end
      #
      # #change to face 2
      # #store first axe before sword
      # unless weapons.empty?
      #   new_ferocity =  4 * (new_ferocity / 5).to_i if weapon == :axe
      #   new_ferocity =  3 * (new_ferocity / 4).to_i if weapon == :sword
      # end
      #

      #change to face 3 THE BATTLE
      # TODO loop do line 940

      if rand() > 0.5 && player.has_torch?
        output << "Your Torch was knocked from your hand.\n"
        items.delete :torch
      end

      if rand() > 0.5 && items.has_key?(:axe)
        output << "You drop your axe in the heat of battle\n"
        items.delete :axe
        new_ferocity = 5 * (new_ferocity / 4).to_i
      end

      if rand() > 0.5 && items.has_key?(:sword)
        output << "Your Sword is knocked from your hand!!!\n"
        items.delete :sword
        new_ferocity = 4 * (new_ferocity / 3).to_i
      end


      if rand() > 0.5
        output << "Attacks.\n"
      else
        output << "**** You attack. ***** \n"
        if rand() > 0.5
          output << "You managed to wound it"
          new_ferocity = (5 * new_ferocity / 6).to_i
        end
      end

      if rand() >  0.95
        output << "Aaaaargh!!\n"
        output << "Rip! Tear! Rip!\n"
      end

      output << "You Want to run but you stand your ground...\n" if rand() > 0.9
      output << '*&%%$#$% $%# !! @ #$$# #$@! #$ $#$' if rand() > 0.9
      output << "Will this be a battle to the death?\n" if rand() > 0.7
      output << "His eyes flash fearfully\n" if rand() > 0.7
      output << "Blood drips from his claws\n" if rand() > 0.7
      output << "You smell the sulphur on his breath\n" if rand() > 0.7
      output << "He strikes wildly, madly......\n" if rand() > 0.7
      output << "You have never fought and opponent like this!!\n" if rand() > 0.7

      if rand() > 0.5
        output << "The monster wounds you!!!\n"
        player.strength -= 5
      end

      # TODO implement the to_s from monster

      #if the condition of the loop do is false
      if rand() * 16 > new_ferocity
        output << "You managed to kill  #{@game.current_room_model.monster.name}\n"
        player.monsters_killed += 1
        @game.current_room_model.update(:monster_id => nil) #Update the monster
      else
        output << "The #{@game.current_room_model.monster.name} defeated you\n"
        player.strength /= 2
      end

      @game.state = ExploringState.new @game
      output << "\n"
      output << @game.state.status
      output
  end
end

#game.current_room = room.name
