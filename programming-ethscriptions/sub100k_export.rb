require 'scribelite'



ScribeDb.open( './sub100k.db' )

puts
puts "  #{Scribe.count} scribe(s)"
puts "  #{Tx.count} tx(s)"


## update bytes (content length) if available
Scribe.order( :num ).each do |scribe|
  next if scribe.flagged?
 
  next if [10198].include?(scribe.num)

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
      puts "==> exporting #{scribe.num}.#{format} (#{scribe.bytes} bytes) ..."
 
      data, content_type  = DataUri.parse( scribe.tx.data )
      ## double check content type - why? why not?

      write_blob( "./tmp/sub100k/#{scribe.num}.#{format}", data )
    end
end



puts "bye"

__END__

fix
raise ArgumentError, "invalid datauri - cannot match regex; sorry"
==> exporting 10198.jpg (11928 bytes) ...
