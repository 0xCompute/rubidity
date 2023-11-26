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


## try more stats

## Let's query for the ten biggest (by bytes) inscribes 
## (and pretty print the result):

Scribe.biggest.limit(20).each do |scribe|
  print "#{number_to_human_size(scribe.bytes)} (#{scribe.bytes} bytes) - "
  print "Scribe №#{scribe.num} (#{scribe.content_type}) - "
  print "#{scribe.tx.date}"    # - #{scribe.tx.}.fee} fee in ??"
  print "\n"
end


## Let's query for all inscriptions grouped by date (day) 
## and dump the results:
pp Scribe.counts_by_day   
pp Scribe.counts_by_year
pp Scribe.counts_by_month
pp Scribe.counts_by_hour


## Let's query for all content types and group by count (descending) 
## and dump the results:
pp Scribe.counts_by_content_type

pp Scribe.counts_by_block
pp Scribe.counts_by_block_with_timestamp

pp Scribe.counts_by_address   # from (creator/minter)



puts "bye"