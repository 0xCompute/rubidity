##
# to runu use:
#   $ ruby sandbox/export_abi.rb


require_relative 'helper'


pp Type.value_types


require_relative 'testtoken'



pp TestToken.state_variable_definitions
pp TestToken.parent_contracts 
pp TestToken.events 

sigs = TestToken.sigs 
puts
puts "#{sigs.size} sigs:"
pp sigs


pp TestToken.is_abstract_contract

abi = TestToken.abi

abi = TestToken.public_abi
pp abi
puts "  #{abi.size} abi(s)"


## todo/check:
##   double-check if on first create some (more) functions added???

contract = TestToken.create
pp contract


abi = TestToken.public_abi
pp abi
puts "  #{abi.size} abi(s)"



abi = TestToken.abi
puts "  as_json:"
pp abi.public_abi_as_json
puts "  to_json:"
puts abi.public_abi_to_json

puts "bye"
