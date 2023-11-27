$LOAD_PATH.unshift( "../scribelite/lib" )
require 'scribelite'



ScribeDb.open( './scribe.db' )


puts
puts "  #{Scribe.count} scribe(s)"
puts "  #{Tx.count} tx(s)"


puts "bye"