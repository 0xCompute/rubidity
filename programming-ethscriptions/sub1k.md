
[« Programming Ethscriptions - Step-by-Step Book / Guide](./)



# Sub 1k - Inside The First Thousand Ethscriptions


Let's explore the first thousand ethscriptions 
from [inscribe  №0](https://ethscriptions.com/ethscriptions/0)
to [inscribe №999](https://ethscriptions.com/ethscriptions/999).

<!--
  change to txid from num - why? why not?
-->


## Step 0:  Let's build the sub1k (SQL) database (scribelite / sqlite)

Let's setup and build from scratch / zero 
a single-file SQLite database (e.g. `sub1k.db`) with
the first thousand ethscriptions, 
that is, all metadata and transaction (call) data, that is, images or text or  whatever.

To fetch the inscription metadata and transaction (call) data
let's use the ethscriptions.com api wrapper / client, that is,
the [ethscribe gem](../ethscribe). 

To setup and build the SQL schema / tables
and insert (& update) all database records let's use
the ethscriptions sqlite database helpers & machinery, that is, the [scribelite gem](../scribelite).


Let's get started:

``` ruby
require 'scribelite'

ScribeDb.open( './sub1k.db' )


puts
puts "  #{Scribe.count} scribe(s)"
puts "  #{Tx.count} tx(s)"
#=>   0 scribe(s)
#=>   0 tx(s)

(1..40).each do |page|   # 1000 ethscriptions = 25 page (batch) size*40 page requests
    ScribeDb.import_ethscriptions( page: page )
end
```

Show time! Let's run the [`sub1k_build` script](sub1k_build.rb) and 
once
all 40 web (api) requests are processed 
you will have a copy of all sub1k ethscriptions with all metadata and transaction (call) data in a single-file SQLite database (about 1.5 MB).


## Let's query and analyze the sub1k inscriptions via SQL


Let's try a test run ...

``` ruby
require 'scribelite'


ScribeDb.open( './sub1k.db' )

puts
puts "  #{Scribe.count} scribe(s)"
puts "  #{Tx.count} tx(s)"
#=>   1000 scribe(s)
#=>   1000 tx(s)
```



## Aside - What's Flagged?! Yes, Removed By Request of Right Holder

Did you know? The ethscriptions.com api honors take downs and on request
removes inscription data for right holders!

Let's try a test run to check-up how many inscribes are take down / flagged
in the first thousands ...

``` ruby
flagged_count =  Scribe.where( flagged: true ).count
#=> 945 !!!!!!!!!
unflagged_count =  Scribe.where( flagged: false ).count
#=> 55
``` 

Yes, that's 945 out of 1000 taken down! Okkie, let's work / analyze with what's left.


Let's query for the ten biggest (by bytes) ethscriptions 
(and pretty print the result):

```ruby
Scribe.biggest.limit(10).each do |scribe|
    print "#{number_to_human_size(scribe.bytes)} (#{scribe.bytes} bytes) - "
    print "Scribe №#{scribe.num} (#{scribe.content_type}) - "
    print "#{scribe.tx.date}" 
    print "\n"
end
```

resulting in:

```
75   KB (76754 bytes) - Scribe №10  (image/png)  - 2022-08-30 03:24:05 UTC
69.3 KB (70958 bytes) - Scribe №338 (image/png)  - 2023-06-15 21:31:47 UTC
66.1 KB (67658 bytes) - Scribe №339 (image/png)  - 2023-06-15 21:52:47 UTC
49   KB (50218 bytes) - Scribe №224 (image/png)  - 2023-06-15 09:56:35 UTC
26.7 KB (27359 bytes) - Scribe №243 (image/jpeg) - 2023-06-15 10:59:35 UTC
26.3 KB (26906 bytes) - Scribe №528 (image/png)  - 2023-06-16 21:54:11 UTC
26.2 KB (26807 bytes) - Scribe №244 (image/jpeg) - 2023-06-15 11:00:35 UTC
23.6 KB (24174 bytes) - Scribe №1   (image/png)  - 2017-03-17 19:42:09 UTC
23   KB (23534 bytes) - Scribe №15  (image/png)  - 2023-06-14 23:03:47 UTC
22.6 KB (23131 bytes) - Scribe №204 (image/jpeg) - 2023-06-15 08:55:23 UTC
```


Let's query for all inscriptions grouped by date (day) and dump the results:

```ruby
pp Scribe.counts_by_date   ## or count_by_day
```


resulting in:

```
{"2016-05-29" => 1,
 "2017-03-17" => 1,
 "2017-07-06" => 1,
 "2018-06-29" => 1,
 "2019-07-23" => 1,
 "2019-12-04" => 1,
 "2020-01-08" => 1,
 "2020-02-06" => 1,
 "2020-07-28" => 1,
 "2020-08-22" => 1,
 "2022-08-30" => 1,
 "2023-06-14" => 10,
 "2023-06-15" => 319,
 "2023-06-16" => 660}
```

Let's query for all inscriptions grouped by month and dump the results:

```ruby
pp Scribe.counts_by_month
```

resulting in:

```
{"2016-05" => 1,
 "2017-03" => 1,
 "2017-07" => 1,
 "2018-06" => 1,
 "2019-07" => 1,
 "2019-12" => 1,
 "2020-01" => 1,
 "2020-02" => 1,
 "2020-07" => 1,
 "2020-08" => 1,
 "2022-08" => 1,
 "2023-06" => 989}
```



Let's query for all content types and group by count (descending) and dump the results:


```ruby
pp Scribe.counts_by_content_type
```

resulting in:

```
{nil          => 945, 
 "image/png"  => 46, 
 "image/jpeg" => 6, 
 "image/gif"  => 1, 
 "image/jpg"  => 1, 
 "text/plain" => 1}
```


To be continued...




## Bonus - Let's export (save as ...) all image inscriptions

Let's export (save as ...) all image inscription 
to local files with (mime) content types mapped
to file extensions (e.g. `image/png` to `.png`, `image/jpeg` to `.jpg`, and so on)
and use the the inscription number as its filename ...


``` ruby
require 'scribelite'

ScribeDb.open( './sub1k.db' )

puts
puts "  #{Scribe.count} scribe(s)"
puts "  #{Tx.count} tx(s)"

## update bytes (content length) if available
Scribe.order( :num ).each do |scribe|
  next if scribe.flagged?
 
   # {nil=>75, "image/png"=>20, "image/jpeg"=>3, "image/gif"=>1, "image/jpg"=>1}
    format = if scribe.content_type.start_with?( "image/jpg") ||
                scribe.content_type.start_with?( "image/jpeg")
                'jpg'
             elsif scribe.content_type.start_with?( "image/png")
                'png'
             elsif scribe.content_type.start_with?( "image/gif" )
                'gif'
             else
                nil
            end

    if format
      data, content_type  = DataUri.parse( scribe.tx.data )
 
      puts "==> exporting #{scribe.num}.#{format} (#{scribe.bytes} bytes) ..."
      write_blob( "#{scribe.num}.#{format}", data )
    end
end
```

resulting in:

```
==> exporting 0.jpg (10947 bytes) ...
==> exporting 1.png (24174 bytes) ...
==> exporting 2.gif (258 bytes) ...
==> exporting 3.png (1906 bytes) ...
==> exporting 4.png (4710 bytes) ...
==> exporting 5.png (10202 bytes) ...
==> exporting 6.png (10366 bytes) ...
==> exporting 7.jpg (21895 bytes) ...
==> exporting 8.jpg (6115 bytes) ...
==> exporting 9.jpg (17334 bytes) ...
==> exporting 10.png (76754 bytes) ...
==> exporting 15.png (23534 bytes) ...
==> exporting 17.png (430 bytes) ...
==> exporting 50.png (1042 bytes) ...
...
```


and voila find all exported images in the [/i directory »](i)

![](i/sub1k-export.png)




