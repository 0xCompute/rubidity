##
# update api samples - to run use:
#    $ ruby samples/update.rb


$LOAD_PATH.unshift( './lib' )
require 'ethscribe'


mainnet = Ethscribe::Api.mainnet



def write( name, data )
    puts "==> #{name}"
    puts "  record(s) #{data.size}"  if data.is_a?( Array )
    
    write_json( "./samples/#{name}.json", data )
end

# write( 'ethscriptions.latest', mainnet.ethscriptions )
# write( 'ethscriptions.1',      mainnet.ethscriptions( page: 1 ) )
# write( 'ethscriptions.2',      mainnet.ethscriptions( page: 2 ) )

## get oldest first
# write( 'ethscriptions.1.asc',   mainnet.ethscriptions( page: 1, sort_order: 'asc' ) )
# write( 'ethscriptions.2.asc',   mainnet.ethscriptions( page: 2, sort_order: 'asc' ) )

# write( 'ethscription0' ,       mainnet.ethscription( 0 ) )
# write( 'ethscription1' ,       mainnet.ethscription( 1 ) )
# write( 'ethscription1000' ,    mainnet.ethscription( 1000 ) )
# write( 'ethscription1000000' , mainnet.ethscription( 1_000_000 ) )

# address = '0x2a878245b52a2d46cb4327541cbc96e403a84791'
# write( "ethscriptions_owned_by_#{address}", mainnet.ethscriptions_owned_by( address ) )  


def write_content( num, content )
    extname = if content.type == "image/jpeg"
                 '.jpeg'
              elsif content.type == 'image/png'
                '.png'
              elsif content.type == 'image/gif'
                '.gif'
              else
                 raise "unsupported content type <#{content.type}>; sorry"
              end 
   write_blob(  "./samples/#{num}#{extname}", content.blob )
end



# nums = [0,1,2,3,4] 
nums = []
nums.each do |num|
    write_content( num, mainnet.ethscription_data( num ) )
end

# inscribe no. 0
# sha = '2817fd9cf901e4435253881550731a5edc5e519c19de46b08e2b19a18e95143e'
# write( "ethscription_exists_#{sha}", mainnet.ethscription_exists( sha ) )  

# inscribe no. ??
# sha = '2817fd9cf901e4435253833550731a5edc5e519c19de46b08e2b19a18e95143e'
# write( "ethscription_exists_#{sha}", mainnet.ethscription_exists( sha ) )  


write( 'status' , mainnet.block_status )


puts "bye"