##
#  to run use:
#    $ ruby sandbox/testenum.rb

require_relative 'helper'



require_relative '../testenum'


##
# check metadata
pp TestEnum.state_variable_definitions
pp TestEnum.parent_contracts 
pp TestEnum.events 
pp TestEnum.is_abstract_contract

abi = TestEnum.abi

puts
puts "public_abi:"
pp TestEnum.public_abi




####
# test drive

contract = TestEnum.new
pp contract
puts "serialize:"
pp contract.serialize


pp contract.getChoice
pp contract.setGoStraight
puts "serialize:"
pp contract.serialize

pp contract.getDefaultChoice
pp contract.getLargestValue
pp contract.getSmallestValue


puts 'bye'