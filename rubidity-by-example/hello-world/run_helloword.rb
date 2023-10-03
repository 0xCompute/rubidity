###
#  to run use:
#
#  $ ruby run_helloworld.rb


require_relative  '../helper'   ## use (shared) helper (boot) setup     


require_relative 'helloworld'


pp HelloWorld


pp contract = HelloWorld.construct
pp contract.serialize

pp contract.greet


pp contract2 = HelloWorld.construct
pp contract2.serialize

pp contract2.greet


puts 'bye'


