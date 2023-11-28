require 'cocos'
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

=begin
    dls = doc.css( 'body dl' )
    dls[0].css( 'dt,dd' ).each do |el|
       if el.name == 'dt'
            items << [el.text]
       elsif el.name == 'dd'
            items[-1] << el.text
       else
         puts "!! ERROR - unexpected tag; expected dd|dl; got: #{el.name}"
         exit 1
       end
    end
    items
  
    ## convert to hash
    ##   and check for duplicate
    data = {}
    items.each do |k,v|
        k = k.strip
        v = v.strip
        if data.has_key?( k )
           puts "!! ERROR - duplicate key >#{k}< in:"
           pp items
           exit 1
        end
        data[ k ] = v
    end
    data
=end

    recs
  end
  

  html = read_text( "./tmp/contracts.1.html")
  
  data =  parse_page( html )
  
  pp data
  
  
  puts "bye"