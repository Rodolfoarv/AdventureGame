# Final Project: A Text Adventure Game
# Date: 05-May-2016
# Authors: A01169701 Rodolfo Andrés Ramírez Valenzuela

DB.create_table? :monsters do
  String :name, primary_key: true
  Integer :ferocity
end

#The Monster class will create a monster in a specific room
class Monster < Sequel::Model
  one_to_many :rooms

  # ToString method that prints the name and the ferocity level of that monster
  def to_s
    "#{self.name} | Ferocity: #{self.ferocity}"
  end
end

Monster.unrestrict_primary_key
