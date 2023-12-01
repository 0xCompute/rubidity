$LOAD_PATH.unshift( "../ethscribe/lib" )
$LOAD_PATH.unshift( "../scribelite/lib" )
require 'scribelite'



ScribeDb.open( './facet.db' )


puts
puts "  #{Scribe.count} scribe(s)"
puts "  #{Tx.count} tx(s)"
#=>   ??? scribe(s)
#=>   ??? tx(s)



## fix-fix-fix - add support for block reorgs!!!!

ScribeDb.sync_facet_txns 


puts
puts "  #{Scribe.count} scribe(s)"
puts "  #{Tx.count} tx(s)"
#=>   ??? scribe(s)
#=>   ??? tx(s)


puts "bye"



