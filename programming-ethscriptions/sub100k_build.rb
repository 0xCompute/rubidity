#####
#  build  sub100k.db  (sqlite database with first hundred thousand ethscriptions)

$LOAD_PATH.unshift( "../scribelite/lib" )
require 'scribelite'



ScribeDb.open( './sub100k.db' )


puts
puts "  #{Scribe.count} scribe(s)"
puts "  #{Tx.count} tx(s)"
#=>   0 scribe(s)
#=>   0 tx(s)


# page size = 25,  25*4000 = 100000 ethscriptions

(1..4000).each do |page|
    ScribeDb.import_ethscriptions( page: page )
end

puts
puts "  #{Scribe.count} scribe(s)"
puts "  #{Tx.count} tx(s)"
#=>   100000 scribe(s)
#=>   100000 tx(s)


puts "bye"