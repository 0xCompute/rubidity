$LOAD_PATH.unshift( "../scribelite/lib" )
require 'scribelite'


require_relative 'facet'   ## pullin facet (pretty) printer et al


ScribeDb.open( './facet.db' )


puts
puts "  #{Scribe.count} scribe(s)"
puts "  #{Tx.count} tx(s)"

  

pp Scribe.counts_by_date   ## or count_by_day

pp Scribe.counts_by_month

pp Scribe.counts_by_content_type





facet_count  = Scribe.facet.count
pp facet_count


facet = FacetPrinter.new


log = ''

Scribe.facet.order( :num ).each do |scribe|
  buf = facet.format( scribe ) 
  puts buf

  log << buf
end

write_text( "./tmp/facet.log", log )


puts "bye"

