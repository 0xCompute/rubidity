####
# to run use:
#   $ ruby -I ./lib sandbox/setup.rb

require 'scribelite'


=begin
ScribeDb.connect( adapter:  'sqlite3',
                  database: './scribe.db' )

## build schema
ScribeDb.create_all
=end

ScribeDb.open( './scribe.db' )


puts
puts "  #{Scribe.count} scribe(s)"
puts "  #{Tx.count} tx(s)"


puts "bye"