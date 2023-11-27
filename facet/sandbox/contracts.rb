##
# try to get contract addresses 
#   from https://facetscan.com/contracts
#
#  note: uses "react" - client-side js - try with puppeeteer

require 'cocos'

require 'puppeteer-ruby'
require 'nokogiri'
  

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
def self.wait_in_s() @wait_in_s ||= 10; end




###
# get contracts
def self.contracts

     browser = nil
     page    = nil
     recs    = []

     page_recs = nil 
     offset = 1
     i = 0
     limit  = 9
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


recs = Facetscan::Puppeteer.contracts



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
