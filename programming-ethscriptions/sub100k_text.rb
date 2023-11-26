$LOAD_PATH.unshift( "../scribelite/lib" )
require 'scribelite'



ScribeDb.open( './sub100k.db' )


puts
puts "  #{Scribe.count} scribe(s)"
puts "  #{Tx.count} tx(s)"
#=>   100000 scribe(s)
#=>   100000 tx(s)

text_count = Scribe.text.count
pp text_count


## fix:  datauri.parse  cannot handle "raw" newline
###               using decode_uri_component
##  "data:text/plain;charset=utf-8,%2F%0A"   
broken_uri = %Q<data:text/plain;charset=utf-8,#{URI.encode_uri_component("/\n")}>
pp broken_uri
pp DataUri.parse( broken_uri )

broken_uri = "data:text/plain;charset=utf-8,/\n"
pp DataUri.parse( broken_uri )


__END__

limit = 20
## print text
Scribe.text.order(:num).each do |scribe|
  puts "==> #{scribe.num} @ #{scribe.tx.date} - #{scribe.content_type}   #{number_to_human_size(scribe.bytes)} (#{scribe.bytes} bytes) ..."

  print "!!! >#{scribe.tx.data}<"   unless  DataUri.valid?( scribe.tx.data )
  
    data, content_type  = DataUri.parse( scribe.tx.data )
    ## double check content type - why? why not?
    puts data
    puts
end



puts "bye"

