# Scribelite - Inscription / Inscribe (Ethscription Calldata) SQL Database

scribelite - inscription / inscribe (ethscription calldata) database for ethereum & co; let's you query via sql and more



* home  :: [github.com/s6ruby/rubidity](https://github.com/s6ruby/rubidity)
* bugs  :: [github.com/s6ruby/rubidity/issues](https://github.com/s6ruby/rubidity/issues)
* gem   :: [rubygems.org/gems/scribelite](https://rubygems.org/gems/scribelite)
* rdoc  :: [rubydoc.info/gems/scribelite](http://rubydoc.info/gems/scribelite)



## What's Ethscription Calldata - Ethereum Inscription / Inscribe?!

See [Introducing Ethscriptions - A new way of creating and sharing digital artifacts on the Ethereum blockchain using transaction calldata »](https://medium.com/@dumbnamenumbers/introducing-ethscriptions-698b295d6f2a)



## Usage

The work-in-progess database schema looks like:

``` ruby
ActiveRecord::Schema.define do

create_table :scribes, :id => :string do |t|    
    t.integer    :num, null: false, index: { unique: true, name: 'scribe_nums' }
    t.integer    :bytes
    t.string     :content_type
    ## add allow duplicate opt-in protocol flag e.g. esip6
    t.boolean    :duplicate      ## allows duplicates flag 
    t.boolean    :flagged,  null: false,  default: false  ## censored flag / removed on request
    t.string     :sha,    null: false    ## sha hash as hexstring (but no leading 0)
end

create_table :txs, :id => :string do |t|
    t.binary     :data     # ,  null: false
    t.datetime   :date,  null: false
    t.integer    :block, null: false
    t.integer    :idx,   null: false  ## transaction index (number)

    t.string     :from,  null: false
    t.string     :to,    null: false   

    t.integer    :fee
    t.integer    :value
end  
end 
```


and to setup use it like:

``` ruby
require 'scribelite'

ScribeDb.connect( adapter:  'sqlite3',
                  database: './scribe.db' )

ScribeDb.create_all   ## build schema
```

and lets import the first hundred (page size is 25)  ethscriptions on mainnet (via the ethscriptions.com api):


``` ruby
require 'scribelite'

ScribeDb.open( './scribe.db' )

[1,2,3,4].each do |page|
   ScribeDb.import_ethscriptions( page: page )
end
```



and to query use it like:

``` ruby
require 'scribelite'

ScribeDb.open( './scribe.db' )

puts
puts "  #{Scribe.count} scribe(s)"
puts "  #{Tx.count} tx(s)"


## how many flagged in top 100?
limit = 100

flagged_count =  Scribe.order( :num ).limit(limit).where( flagged: true ).count
pp flagged_count    #=> 75 !!!!!!!!!
unflagged_count =  Scribe.order( :num).limit(limit).where( flagged: false ).count
pp unflagged_count  #=> 25


Scribe.order( :num ).limit(limit).each do |scribe|
    if scribe.flagged?
      print " xx "
    else
      print "==> "
    end
    print "#{scribe.num} / #{scribe.content_type}   -   #{scribe.tx.date} @ #{scribe.tx.block}"
    print "\n"
end


## Let's query for all inscriptions grouped by date (day) 
## and dump the results:
pp Scribe.counts_by_day   
pp Scribe.counts_by_year
pp Scribe.counts_by_month
pp Scribe.counts_by_hour


## Let's query for all content types and group by count (descending) 
## and dump the results:
pp Scribe.counts_by_content_type

pp Scribe.counts_by_block
pp Scribe.counts_by_block_with_timestamp

pp Scribe.counts_by_address   # from (creator/minter) address 

# ...
```

To be continued...





## Bonus - More Blockchain (Crypto) Tools, Libraries & Scripts In Ruby

See [**/blockchain**](https://github.com/rubycocos/blockchain) 
at the ruby code commons (rubycocos) org.


## Questions? Comments?

Join us in the [Rubidity (community) discord (chat server)](https://discord.gg/3JRnDUap6y). Yes you can.
Your questions and commentary welcome.

Or post them over at the [Help & Support](https://github.com/geraldb/help) page. Thanks.

