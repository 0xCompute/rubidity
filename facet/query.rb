$LOAD_PATH.unshift( "../scribelite/lib" )
require 'scribelite'



ScribeDb.open( './facet.db' )


puts
puts "  #{Scribe.count} scribe(s)"
puts "  #{Tx.count} tx(s)"

  

pp Scribe.counts_by_date   ## or count_by_day

pp Scribe.counts_by_month

pp Scribe.counts_by_content_type


## e.g.
##     data:application/vnd.facet.tx+json;rule=esip6,
##          {"op":"call","data":
##             {"to":"0x82dd9ceed833f78d45dd54e2a3755e022b0bad70",
##              "function":"swapExactTokensForTokens",
##              "args":{"amountIn":"5000000000000000",
##                      "amountOutMin":"6308999624399590752944",
##                      "path":["0x5f5e099e59720e515114ae82b855fbcfb9bd07a9",
##                              "0xc0189ae03d30b642c58e2e1b84d1e45fab47f5ed"],
##                      "to":"0xBf4a5d5DcB7F0626c63Df0199091b269893cB6d9",
##                      "deadline":"1000000000000000000"}}}


def parse_tx( datauri )
    ## hack/patch newline (\n) to %0A 
    datauri = datauri.gsub( "\n", "%0A" )

    raw, type = DataUri.parse( datauri )
    unless type.start_with?( 'application/vnd.facet.tx+json' )
      puts "!! ERROR - expected application/vnd.facet.tx+json...; got:"
      puts datauri
      exit 1
    end
    data = JSON.parse( raw )
    data
end


deploys = {
    '0xde11257ac24e96b8e39df45dbd4d3cf32237d63d' => 'FacetSwapV1Router', 
    '0x82dd9ceed833f78d45dd54e2a3755e022b0bad70' => 'FacetSwapV1Router',
    '0x0e1e5810121d4e138df1d293b95cadcc1ccf3bc3' => 'FacetSwapV1Factory',
}


facet_count  = Scribe.facet.count
pp facet_count

Scribe.facet.order( :num ).each do |scribe|
  puts "==> #{scribe.num} - #{scribe.tx.date}   #{number_to_human_size(scribe.bytes)} (#{scribe.bytes} bytes)  ..."
  ## puts  scribe.tx.data
  data = parse_tx( scribe.tx.data )

  op     = data['op']
  to     = data['data']['to']
  args   = data['data']['args']
  
  if op == 'call'
    func  = data['data']['function']

    contract_name = deploys[to] ||  "???" 
 
    puts "   CALL  #{contract_name}.#{func}  - args:"
    pp args
  elsif op == 'create'
    source = data['data']['source_code']
 
    puts "   CREATE  args:"
    pp args
  else
      puts "!! ERROR - unknown facet op:"
      pp data
      exit 1
  end
end

puts "bye"



__END__

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