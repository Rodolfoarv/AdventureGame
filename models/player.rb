# Final Project: A Text Adventure Game
# Date: 05-May-2016
# Authors: A01169701 Rodolfo Andrés Ramírez Valenzuela

DB.create_table? :players do
  primary_key         :id
  String              :name
  Fixnum              :strength
  Fixnum              :wealth
  Fixnum              :monster_tally

end
