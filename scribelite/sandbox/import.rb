####
# to run use:
#   $ ruby -I ./lib sandbox/import.rb

require 'scribelite'



ScribeDb.open( './scribe.db' )

puts
puts "  #{Scribe.count} scribe(s)"
puts "  #{Tx.count} tx(s)"


net   = Ethscribe::Api.mainnet
pages = [1,2,3,4] 


pages.each do |page|
    ## note: sort oldest first (asc[ending])
    recs = net.ethscriptions( page: page, sort_order: 'asc' )


    recs.each_with_index do |rec,i|
        puts "==> page #{page}/#{i+1} - #{rec['transaction_hash']}..."

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
           sha:   sha 
        }

 
        scribe = Scribe.find_by( id: txid )
        if scribe
            ## skip for now - found id db
        else
            puts "scribe_attribs:"
            pp scribe_attribs
               Scribe.create!( **scribe_attribs )
        end
 
        tx = Tx.find_by( id: txid )
        if tx
            ## skip for now - found id db
        else
            puts "tx_attribs:"
            pp tx_attribs
            Tx.create!( **tx_attribs )
        end
    end
end




puts
puts "  #{Scribe.count} scribe(s)"
puts "  #{Tx.count} tx(s)"




puts "bye"