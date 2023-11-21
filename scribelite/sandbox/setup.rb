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
puts "  #{Inscribe.count} inscribe(s)"
puts "  #{Calldata.count} calldata(s)"


puts "bye"