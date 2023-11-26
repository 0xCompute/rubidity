require 'scribelite'



ScribeDb.open( './sub1k.db' )

puts
puts "  #{Scribe.count} scribe(s)"
puts "  #{Tx.count} tx(s)"


## update bytes (content length) if available
Scribe.order( :num ).each do |scribe|
  next if scribe.flagged?
 
   # {nil=>75, "image/png"=>20, "image/jpeg"=>3, "image/gif"=>1, "image/jpg"=>1}
    format = if scribe.content_type.start_with?( "image/jpg") ||
                scribe.content_type.start_with?( "image/jpeg")
                'jpg'
             elsif scribe.content_type.start_with?( "image/png")
                'png'
             elsif scribe.content_type.start_with?( "image/gif" )
                'gif'
             else
                nil
            end

    if format
      data, content_type  = DataUri.parse( scribe.tx.data )
      ## double check content type - why? why not?
 
      puts "==> exporting #{scribe.num}.#{format} (#{scribe.bytes} bytes) ..."
      write_blob( "./tmp/#{scribe.num}.#{format}", data )
    end
end



puts "bye"