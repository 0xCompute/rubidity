##
# to run use:
#   $ ruby sandbox/typed.rb


$LOAD_PATH.unshift( "./lib" )
require 'rubidity/typed'


types = [
  TypedString,
  TypedAddress,
  TypedInscriptionId,
  TypedBytes32,
  TypedBytes,
  TypedBool,
  TypedUInt, 
  TypedInt, 
  TypedTimestamp,   
]


types.each do |typedclass|
    puts "==> #{typedclass.name} - #{typedclass.inspect}:"
 
    type = typedclass.type 
    pp type
    print "zero: "
    print type.zero.pretty_print_inspect
    print "\n"

    print "new_zero: "
    print type.new_zero.pretty_print_inspect
    print "\n"

    print "new: "
    print type.new.pretty_print_inspect
    print "\n"

    print "typedclass.name: "
    print type.typedclass.name
    print "\n"
end


puts 'bye'