####
# to run use:
#   $ ruby -I ./lib sandbox/import.rb

require 'scribelite'



ScribeDb.open( './scribe.db' )

puts
puts "  #{Scribe.count} scribe(s)"
puts "  #{Tx.count} tx(s)"


pages = [1,2,3,4] 
pages.each do |page|
   ScribeDb.import_ethscriptions( page: page )
end


puts
puts "  #{Scribe.count} scribe(s)"
puts "  #{Tx.count} tx(s)"




puts "bye"