

module ScribeDb



## note: by default - sort asc(ending) - oldest first (0,1,2,3, .etc.)
def self.import_ethscriptions( page: 1, 
                               per_page: 50, 
                               sort_order: 'asc' )
    net   = Ethscribe.config.client
    recs = net.ethscriptions( page: page,
                              per_page: per_page, 
                              sort_order: sort_order )

    puts "  #{recs.size} record(s)"                          

    recs.each_with_index do |rec,i|
        puts "==> page #{page}/#{i+1} - #{rec['transaction_hash']}..."
        _import_ethscription( rec )
    end

    recs.size   ## return number of records fetched for now
end  # method import_ethscriptions


def self.sync_facet_txs
  net   = Ethscribe.config.client

  ## add block argument - why? why not? 
  ## get count by block e.g.
  ##   our_count = Scribe.joins(:tx).where( 'block < ?', new_block_number).count
 

  count = Scribe.count
 
  block =  if count > 0
               last_scribe =  Scribe.where( num: Scribe.maximum(:num) ).first
               last_scribe.tx.block + 1
           else
             0
           end

  loop do 
    res = net.newer_facet_txs( block, max: 2500, count: count )

    break   if res['blocks'].size == 0

    first_block = res['blocks'][0]['block_number']
    last_block  = res['blocks'][-1]['block_number']
    puts "==>  #{res['blocks'].size} block(s)  - #{first_block} to #{last_block}..."
    puts "        total_future_ethscriptions: #{res['total_future_ethscriptions']}"

    batch_count = 0
    res['blocks'].each do |block_rec|
        block_rec['ethscriptions'].each do |rec|
             _import_ethscription( rec )
             count += 1
             batch_count += 1
        end
    end
    puts "      #{batch_count} record(s) added"

    block = last_block + 1

    break  if res['total_future_ethscriptions'] == 0
  end
end  # method sync_facet_txs
class << self
  alias_method :sync_facet_txns, :sync_facet_txs
end



def self._import_ethscription( rec )
    txid  = rec['transaction_hash']
    block = rec['block_number']
    idx   = rec['transaction_index']
    
    from  = rec['creator']
    to    = rec['initial_owner']

    ## todo - double check if daylight saving time (dst) breaks timestamp == utc identity/conversion?
    ##  2001-02-03T04:05:06+07:00
    ##  2016-05-29T22:28:15.000Z
    ##  check if %z can handle  .000Z ??
    ##  DateTime.strptime( '2016-05-29T22:28:15.000Z', '%Y-%m-%dT%H:%M:%S%z' )
    ## pp rec['creation_timestamp']
    date  = DateTime.strptime( rec['creation_timestamp'], '%Y-%m-%dT%H:%M:%S.000Z' )   
    

    num   = rec['ethscription_number']
    content_type = rec['mimetype']
    data = rec['content_uri']
    sha  = rec['sha']

    duplicate = rec['esip6']
    flagged   = rec['image_removed_by_request_of_rights_holder']

   ### check - if flagged
   ##  content_type always set to text/plain
   ##     and data to data:,  ???
   ##   (re)set to nil/null - why? why not?
     if flagged
        data         = nil
        content_type = nil
     end
    
    tx_attribs = {
       id:   txid,
       block: block,
       idx:   idx,
       date:  date,
       from:  from,
       to:    to,
       data:  data,   ## note: for now saved as utf8 string (not hex!!!!)
    }

    scribe_attribs = {
       id: txid,
       num:  num,
       content_type: content_type,
       duplicate: duplicate,
       flagged: flagged,
       sha:   sha, 
       bytes: data ? data.length : nil    ## auto-add/calc bytes (content length)
    }

    if num.nil?
         puts "!! skipping unconfirmed / unassigned inscribe - no. num"
         return
    end


    scribe = Scribe.find_by( id: txid )
    if scribe
        ## skip for now - found id db
    else
        # puts "scribe_attribs:"
        # pp scribe_attribs
        Scribe.create!( **scribe_attribs )
    end

    tx = Tx.find_by( id: txid )
    if tx
        ## skip for now - found id db
    else
        # puts "tx_attribs:"
        # pp tx_attribs
        Tx.create!( **tx_attribs )
    end
end

end  # module ScribeDb
 