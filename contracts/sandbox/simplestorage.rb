##
#  to run use:
#    $ ruby sandbox/simplestorage.rb

require_relative 'helper'



require_relative '../simplestorage'

##
# check metadata
pp SimpleStorage.state_variable_definitions
pp SimpleStorage.parent_contracts 
pp SimpleStorage.events 
pp SimpleStorage.is_abstract_contract

abi = SimpleStorage.abi

puts
puts "public_abi:"
pp SimpleStorage.public_abi


##
# test drive

contract = SimpleStorage.create
pp contract

pp contract.constructor()
pp contract

pp contract.state_proxy.serialize

pp contract.get

pp contract.set( 123 )
pp contract.state_proxy.serialize

pp contract.get
pp contract.set( 456 )
pp contract.state_proxy.serialize

pp contract.get




puts "bye"