####
# to run use:
#   $ ruby -I ./lib sandbox/query2.rb

require 'scribelite'



ScribeDb.open( './scribe.db' )

puts
puts "  #{Scribe.count} scribe(s)"
puts "  #{Tx.count} tx(s)"


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

pp Scribe.content_type_counts
  
pp Scribe.counts_by_block
pp Scribe.counts_by_block_with_timestamp


puts "bye"