# Quick Scratch Notes


## facet to address is NOT 0x0 BUT  0x0..face7!!!

see <https://etherscan.io/address/0x00000000000000000000000000000000000face7>
to track transactions!

why?  easier to track - get all txns sent to 0x0..face7!  
0x0 is too generic (used by many others too incl. default for contract creation and burning etc.)

see <https://etherscan.io/address/0x0000000000000000000000000000000000000000>


double check: - if 0x0 is still an option in facet or 0x..face7 only?




## sync log 

```
==>  144 block(s)  - 18691986 to 18692129...
        total_future_ethscriptions: 0
!! skipping unconfirmed / unassigned inscribe - no. num
!! skipping unconfirmed / unassigned inscribe - no. num
!! skipping unconfirmed / unassigned inscribe - no. num
!! skipping unconfirmed / unassigned inscribe - no. num
      255 record(s) added

  66245 scribe(s)
  66245 tx(s)
```


## stats 

```
  66245 scribe(s)
  66245 tx(s)
{"2023-11-22"=>1, 
 "2023-11-29"=>5, 
 "2023-11-30"=>34612, 
 "2023-12-01"=>31627}
{"application/vnd.facet.tx+json"=>66240, 
 "application/vnd.facet.system+json"=>5}

66240  (+ 5 system)
```


## media types usage


```
## first 1000

{"image/png"=>412,
 "text/plain"=>290,
 "application/json"=>262,
 "image/jpeg"=>30,
 "image/svg+xml"=>4,
 nil=>1,
 "text/html"=>1}


 ## with latest

 {"application/json"=>927,
 "image/png"=>414,
 "text/plain"=>325,
 "application/vnd.facet.tx+json"=>266,
 "image/jpeg"=>30,
 "image/svg+xml"=>28,
 "text/html"=>8,
 nil=>1}
 ```