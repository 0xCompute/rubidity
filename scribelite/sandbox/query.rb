####
# to run use:
#   $ ruby -I ./lib sandbox/query.rb

require 'scribelite'



ScribeDb.open( './scribe.db' )

puts
puts "  #{Scribe.count} scribe(s)"
puts "  #{Tx.count} tx(s)"



## how many flagged in top 100?

limit = 100

flagged_count =  Scribe.order( :num ).limit(limit).where( flagged: true ).count
pp flagged_count    #=> 75 !!!!!!!!!
unflagged_count =  Scribe.order( :num).limit(limit).where( flagged: false ).count
pp unflagged_count  #=> 25


Scribe.order( :num ).limit(limit).each do |scribe|
    if scribe.flagged?
      print " xx "
    else
      print "==> "
    end
    print "#{scribe.num} / #{scribe.content_type}   -   #{scribe.tx.date} @ #{scribe.tx.block}"
    print "\n"
end


puts "bye"