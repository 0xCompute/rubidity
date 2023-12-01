##
# try to get all facet transactions (txs) - to run use:
#    $ ruby sandbox/facet.rb


$LOAD_PATH.unshift( './lib' )
require 'ethscribe'


mainnet = Ethscribe::Api.mainnet


def dump( data )
  puts "   total_future_ethscriptions: #{data['total_future_ethscriptions']}"
    ## get number of blocks
    ## get number of tx(n)s
    ## get number of blocks with tx(n)s  - non-empty

    block_count = data['blocks'].size
    tx_count          = 0
    facet_block_count = 0

    data['blocks'].each do |block|
        count = block['ethscriptions'].size
        if count > 0
           tx_count += count
           facet_block_count += 1
        end
    end
    

    first_block = data['blocks'][0]['block_number']
    last_block  = data['blocks'][-1]['block_number']
  
    puts "  #{block_count} blocks(s) -  #{first_block} to #{last_block}" 
    puts "               #{tx_count} txn(s) in #{facet_block_count} blocks(s)" 
    puts

#
# ==> facet_0
#  total_future_ethscriptions: 65951
#    9999 blocks(s) -  18628099 to 18638097
#                1 txn(s) in 1 blocks(s)
# ==> facet_18638098
#   total_future_ethscriptions: 65964
#  9999 blocks(s) -  18638098 to 18648096
#               0 txn(s) in 0 blocks(s)


# total_future_ethscriptions: 65896
# 6815 blocks(s) -  18678094 to 18684908
#             77 txn(s) in 16 blocks(s)

# ==> facet_18684909
#   total_future_ethscriptions: 65814
#  9 blocks(s) -  18684909 to 18684917
#               89 txn(s) in 6 blocks(s)
end


def write( name, data )
    puts "==> #{name}"
    dump( data )
    write_json( "./samples/#{name}.json", data )
end


write( 'facet_0', mainnet.newer_facet_txs( 0, max: 100 ))
write( 'facet_18638098', mainnet.newer_facet_txs( 18638098, max: 100, count: 1 ))
write( 'facet_18668095', mainnet.newer_facet_txs( 18668095, max: 100, count: 1 ))
write(  'facet_18678094', mainnet.newer_facet_txs( 18678094, max: 100, count: 2 ))
write(  'facet_18684909', mainnet.newer_facet_txs( 18684909, max: 100, count: 79 ))


puts "bye"