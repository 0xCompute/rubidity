##
# to run use:
#   $ ruby sandbox/typed.rb


$LOAD_PATH.unshift( "./lib" )
require 'rubidity/typed'


module Sandbox


types = [
  String,
  Address,
  InscriptionId,
  Bytes32,
  Bytes,
  Bool,
  UInt, 
  Int, 
  Timestamp,   
]


types.each do |typedclass|
    puts "==> #{typedclass.name} - #{typedclass.inspect}:"
 
    type = typedclass.type 
    pp type

    print "mut? "
    print type.mut?
    print "\n"

    ## note: zero only availabe for immutable types 
    ##       MUST use new_zero for mutable (mut? == true) types!!! 
    print "zero: "
    print type.zero.pretty_print_inspect
    print "\n"

    print "new_zero: "
    print type.new_zero.pretty_print_inspect
    print "\n"

 #   print "new: "
 #   print type.new(  ).pretty_print_inspect
 #   print "\n"

    print "typedclass.name: "
    print type.typedclass.name
    print "\n"
end


puts 'bye'

end  # module Sandbox
