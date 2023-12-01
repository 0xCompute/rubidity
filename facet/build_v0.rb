$LOAD_PATH.unshift( "../scribelite/lib" )
require 'scribelite'



ScribeDb.open( './facet.db' )


puts
puts "  #{Scribe.count} scribe(s)"
puts "  #{Tx.count} tx(s)"
#=>   0 scribe(s)
#=>   0 tx(s)


# page size = 25,  25*40 = 1000 ethscriptions

## switch to goerli testnet for now
Ethscribe.config.chain = 'goerli'

(1..40).each do |page|
    ScribeDb.import_ethscriptions( page: page, sort_order: 'desc' )
end

puts
puts "  #{Scribe.count} scribe(s)"
puts "  #{Tx.count} tx(s)"
#=>   1000 scribe(s)
#=>   1000 tx(s)


puts "bye"