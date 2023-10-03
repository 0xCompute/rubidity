###
#  to run use:
#
#  $ ruby run_simplestorage.rb


require_relative  '../helper'   ## use (shared) helper (boot) setup     


require_relative 'simplestorage'


pp SimpleStorage


pp contract = SimpleStorage.construct
pp contract.serialize

pp contract.get
pp contract.set( 1 )
pp contract.get
pp contract.set( 999 )
pp contract.get


pp contract2 = SimpleStorage.construct
pp contract2.serialize

pp contract2.get
pp contract2.set( 42 )
pp contract2.get

puts 'bye'
