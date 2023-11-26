$LOAD_PATH.unshift( "../scribelite/lib" )
require 'scribelite'



ScribeDb.open( './sub1k.db' )


puts
puts "  #{Scribe.count} scribe(s)"
puts "  #{Tx.count} tx(s)"
#=>   0 scribe(s)
#=>   0 tx(s)


flagged_count =  Scribe.where( flagged: true ).count
pp flagged_count    #=> 945 !!!!!!!!!
unflagged_count =  Scribe.where( flagged: false ).count
pp unflagged_count  #=> 55


puts "bye"