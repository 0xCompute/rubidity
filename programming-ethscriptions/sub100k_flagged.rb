$LOAD_PATH.unshift( "../scribelite/lib" )
require 'scribelite'



ScribeDb.open( './sub100k.db' )


puts
puts "  #{Scribe.count} scribe(s)"
puts "  #{Tx.count} tx(s)"
#=>   100000 scribe(s)
#=>   100000 tx(s)


flagged_count =  Scribe.where( flagged: true ).count
pp flagged_count    #=> 13343 !!!!!!!!!
unflagged_count =  Scribe.where( flagged: false ).count
pp unflagged_count  #=> 86657


puts "bye"