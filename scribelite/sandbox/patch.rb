####
# to run use:
#   $ ruby -I ./lib sandbox/patch.rb

require 'scribelite'



ScribeDb.open( './scribe.db' )

puts
puts "  #{Scribe.count} scribe(s)"
puts "  #{Tx.count} tx(s)"


## update bytes (content length) if available
Scribe.order( :num ).each do |scribe|
  next if scribe.flagged?
 
  if scribe.bytes.nil?
     bytes = scribe.tx.data.length 
     scribe.update!( bytes: bytes ) 
  end
end



puts "bye"