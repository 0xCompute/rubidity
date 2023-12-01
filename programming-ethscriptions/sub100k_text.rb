$LOAD_PATH.unshift( "../datauris/lib" )
$LOAD_PATH.unshift( "../scribelite/lib" )
require 'scribelite'



ScribeDb.open( './sub100k.db' )


puts
puts "  #{Scribe.count} scribe(s)"
puts "  #{Tx.count} tx(s)"
#=>   100000 scribe(s)
#=>   100000 tx(s)

text_count = Scribe.text.count
pp text_count     # 77522 (!)



limit = 100

buf = ''

## print text
Scribe.text.order(:num).limit( limit).each_with_index do |scribe,i|
  puts "==> #{scribe.num} @ #{scribe.tx.date} - #{scribe.content_type}   #{number_to_human_size(scribe.bytes)} (#{scribe.bytes} bytes) ..."
  
    data, content_type  = DataUri.parse( scribe.tx.data, utf8: true )
    ## double check content type - why? why not?
    puts data
    puts

    buf << "==> no. #{i+1}  - #{scribe.num} @ #{scribe.tx.date} - #{scribe.content_type}   #{number_to_human_size(scribe.bytes)} (#{scribe.bytes} bytes)\n"
    buf << data
    buf << "\n\n"
  end
  write_text( "./sub100k.txt", buf )



  buf = ''

## print text
##  exclude biggies > 1024
  Scribe.text.order(:num).where( 'bytes < 1024' ).limit( limit).each_with_index do |scribe,i|
    puts "==> #{scribe.num} @ #{scribe.tx.date} - #{scribe.content_type}   #{number_to_human_size(scribe.bytes)} (#{scribe.bytes} bytes) ..."
    
      data, content_type  = DataUri.parse( scribe.tx.data, utf8: true )
      ## double check content type - why? why not?
      puts data
      puts
  
      buf << "==> no. #{i+1}  - #{scribe.num} @ #{scribe.tx.date} - #{scribe.content_type}   #{number_to_human_size(scribe.bytes)} (#{scribe.bytes} bytes)\n"
      buf << data.force_encoding( 'utf-8' )
      buf << "\n"
    end
  

write_text( "./sub100k_sub1k.txt", buf )


puts "bye"

