$LOAD_PATH.unshift( "../scribelite/lib" )
require 'scribelite'



ScribeDb.open( './scribe.db' )


puts
puts "  #{Scribe.count} scribe(s)"
puts "  #{Tx.count} tx(s)"


## get latest scribe num
##  100002 max. scribe number !!!
##   check what two (or three) numbers below 100002 are missing!!! 

max = Scribe.maximum( :num )
pp max
puts "   #{max} max. scribe number"

page = max / 25
puts "   #{page} page offset for restart"



loop do 
    ScribeDb.import_ethscriptions( page: page )
    page += 1
end


puts
puts "  #{Scribe.count} scribe(s)"
puts "  #{Tx.count} tx(s)"


puts "bye"