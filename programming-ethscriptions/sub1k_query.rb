$LOAD_PATH.unshift( "../scribelite/lib" )
require 'scribelite'



ScribeDb.open( './sub1k.db' )


puts
puts "  #{Scribe.count} scribe(s)"
puts "  #{Tx.count} tx(s)"
#=>   0 scribe(s)
#=>   0 tx(s)

Scribe.biggest.limit(20).each do |scribe|
    print "#{number_to_human_size(scribe.bytes)} (#{scribe.bytes} bytes) - "
    print "Scribe №#{scribe.num} (#{scribe.content_type}) - "
    print "#{scribe.tx.date}"    # - #{scribe.tx.}.fee} fee in ??"
    print "\n"
end
  

pp Scribe.counts_by_date   ## or count_by_day

pp Scribe.counts_by_month


pp Scribe.counts_by_content_type


puts "bye"