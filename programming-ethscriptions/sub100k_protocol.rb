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


count = 0
limit = 100
## print text
Scribe.text.order(:num).each do |scribe|
  
  next  if [10394, 13284].include?( scribe.num )
 
=begin - fix-fix-fix
  no. 13284
  _decode_uri_component': invalid %-encoding (#%�-%�) (ArgumentError)

  raise ArgumentError, "invalid %-encoding (#{str})" if /%(?!\h\h)/.match?(str))
=end

  ## puts " no. #{scribe.num}"
  print "!!!  #{scribe.num}  >#{scribe.tx.data}<"   unless  DataUri.valid?( scribe.tx.data )

  data, content_type  = DataUri.parse( scribe.tx.data )
 
  if data.start_with?( /[ ]*{/ )   ## allow leading space - why? why not?
    puts "==> #{scribe.num} @ #{scribe.tx.date} - #{scribe.content_type}   #{number_to_human_size(scribe.bytes)} (#{scribe.bytes} bytes) ..."
  
    ## double check content type - why? why not?
    puts data
    puts

    count += 1
  else
=begin
    print "xx  #{scribe.num}   - #{data[0,40]}"
    chr = data[40]
    print ".."    if chr  ### why data[40].nil not working???
    ## print " >#{chr}< #{data.length}" 
    print " (#{scribe.bytes} bytes)"
    print "\n"
=end
  end

  break if count >= limit
end



puts "bye"


__END__

==> 13819 @ 2023-06-17 11:15:59 UTC - text/plain   119 Bytes (119 bytes) ...
{"p":"erc-20","op":"deploy","tick":"pepe","max":"21000000","lim":"7000"}

==> 13832 @ 2023-06-17 11:16:35 UTC - text/plain   127 Bytes (127 bytes) ...
{"p":"ebrc-20","op":"deploy","tick":"ebrc","max":"4200000000","lim":"100000"}

==> 13893 @ 2023-06-17 11:19:59 UTC - text/plain   95 Bytes (95 bytes) ...
{"p":"erc-20","op":"mint","tick":"pepe","amt":"7000"}

==> 15985 @ 2023-06-17 15:29:35 UTC - text/plain   78 Bytes (78 bytes) ...
{"p":"brc-20","op":"deploy","tick":"eths","max":"21000000","lim":"1000"}

==> 15992 @ 2023-06-17 15:30:59 UTC - text/plain   46 Bytes (46 bytes) ...
{"p":"eons","op":"reg","name":"0.eon"}

==> 15998 @ 2023-06-17 15:31:35 UTC - text/plain   59 Bytes (59 bytes) ...
{"p":"brc-20","op":"mint","tick":"eths","amt":"1000"}

==> 16001 @ 2023-06-17 15:31:47 UTC - text/plain   45 Bytes (45 bytes) ...
{"p":"eons","op":"reg","name":".eon"}


