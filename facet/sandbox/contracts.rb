##
# try to get contract addresses 
#   from https://facetscan.com/contracts
#
#  note: uses "react" - client-side js - try with puppeeteer

require 'cocos'

require 'puppeteer-ruby'
require 'nokogiri'
  



def parse_page( html )
  doc = Nokogiri::HTML( html )

  recs = []

  ## assume big table
  tables = doc.css( 'table' )
  puts "#{tables.size }table(s)"
  table = tables[0]

  ths = table.css( 'thead tr th')
  puts "#{ths.size } table headings(s)"
 
  names = ths.map { |th| th.text }
  pp names
  ## recs << names

  trs = table.css( 'tbody tr' )
  puts "#{trs.size} table row(s)"

  trs.each_with_index do |tr,i|
      rec = []
      puts "==> row #{i+1}"
      tds = tr.css( 'td' )
      puts "#{tds.size} table data(s)"

      # td[0] ->  Contract Address
      # td[1] -> Contract Type
      # td[2] ->  Deployer
      # td[3] -> Deployment Txn
      # td[4] -> Age

      # no.3
      #  <td><div>
      #   <a href="/tx/0x6ab7ac6fab2ceed26ef35f68063fe131748540a839f8f0163915b2f04067e1e4">
      #      0x6ab7ac...4067e1e4
      #   </a></div></td>

      href = tds[3].at( 'a' )['href'].sub( '/tx/', '' )
      rec << href

      # no.1
      #  <td><div>PublicMintERC20</div></td>
      text = tds[1].at( 'div' ).text.strip
      rec << text


      ## no.0 
      ## <td>
      ##  <a href="/address/0xd777fd9e86f1a13edf9dfcf9eed8d01cfb538ec1">
      ##    0xd777fd...fb538ec1
      ##  </a></td>
      
      href = tds[0].at( 'a' )['href'].sub( '/address/', '' )
      rec << href


      recs << rec
  end
  recs
end



module Facetscan
module Puppeteer

###
##  todo: use a config block in the future - why? why not?
def self.chrome_path=( path )
  if File.exist?( path )
    puts "** bingo! found chrome executable @ path >#{path}<"
  else
    puts "*** ERROR - sorry; cannot find chrome executable @ path >#{path}<"
    exit 1
  end

  @chrome_path = path
end

def self.chrome_path() @chrome_path; end

## use/rename to wait_in_secs - why? why not? 
def self.wait_in_s=( s ) @wait_in_s = s; end 
def self.wait_in_s() @wait_in_s ||= 4; end




###
# get contracts
def self.contracts( limit: )

     browser = nil
     page    = nil
     recs    = []

     page_recs = nil 
     offset = 1
     i = 0
     loop do     
      break  if limit && i >= limit                               
      count = offset+i

      page_url  = "https://facetscan.com/contracts?page=#{count}"
      print page_url
     

      if browser.nil?    ## first page request? launch browser on demand
        opts = {}
        opts[:headless]        = false
        opts[:executable_path] = chrome_path  if chrome_path   ## add only if set (default is nil)
        
        browser = ::Puppeteer.launch( **opts )    
        page    = browser.new_page
      end

      print "... goto page ...\n"
      response = page.goto( page_url )
      pp response.headers

      puts "sleeping #{wait_in_s} sec(s)..."
      sleep( wait_in_s )
  

     table_sel = 'table.min-w-full.text-left.divide-y.divide-line'      

      ## print search result summary / counts
      page.wait_for_selector( table_sel )

      el =  page.query_selector( table_sel )
    
      ## get table with contracts
      html = el.evaluate( "el => el.outerHTML" )
      puts
      puts html
 
      write_text( "./tmp/contracts.#{count}.html", html )
 
      recs += parse_page( html )

      i += 1
    end  # loop

    if browser 
       puts "sleeping 2 secs before browser shutdown..."
       sleep( 2 )
       browser.close
    end

    recs
end  # method search  
end # module Puppeteer
end # module  Facetscan



## add alternate name alias - why? why not?
FacetScan = Facetscan



CHROME_PATH = 'C:\Program Files\Google\Chrome\Application\chrome.exe'
Facetscan::Puppeteer.chrome_path = CHROME_PATH


recs = Facetscan::Puppeteer.contracts( limit: 17 )

headers = ['txid','name','address']
buf = headers.join( ',' )
buf << "\n"
recs.each do |values|
   buf << values.join( ',' )
   buf << "\n"
end

write_text( "./tmp/contracts.csv", buf )




puts "bye"


__END__

https://facetscan.com/contracts?page=1... goto page ...
{"age"=>"0",
 "cache-control"=>"private, no-cache, no-store, max-age=0, must-revalidate",
 "content-encoding"=>"br",
 "content-type"=>"text/html; charset=utf-8",
 "date"=>"Mon, 27 Nov 2023 17:41:05 GMT",
 "server"=>"Vercel",
 "strict-transport-security"=>"max-age=63072000",
 "vary"=>"RSC, Next-Router-State-Tree, Next-Router-Prefetch, Next-Url",
 "x-matched-path"=>"/contracts",
 "x-powered-by"=>"Next.js",
 "x-vercel-cache"=>"MISS",
 "x-vercel-execution-region"=>"iad1",
 "x-vercel-id"=>"fra1::iad1::xtc2k-1701106863606-61138eaf18d4"}
