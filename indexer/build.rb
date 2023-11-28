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

per_page = 50     # note: 50 per page is max on ethscriptions.com request (default is: 25)
page     = max / per_page
puts "   #{page} page offset for restart"



loop do 
    recs  = ScribeDb.import_ethscriptions( page: page, per_page: per_page )
    break if recs < per_page     ## assume last page has returned less records

    page += 1
end

puts
puts "  #{Scribe.count} scribe(s)"
puts "  #{Tx.count} tx(s)"


puts "bye"