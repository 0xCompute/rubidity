


class FacetPrinter


def initialize(  contracts_path='./contracts.csv' )

  ## read-in all known contract creates/deploys

  recs = read_csv( contracts_path )

  ## build a lookup table by txid
  @deploys_by_txid = {}
  @deploys = {}   ## by address

  recs.each do |rec|
    txid    = rec['txid']
    name    = rec['name']
    address = rec['address']

    @deploys_by_txid[ txid ] = { 'name'     => name,
                                 'address'  => address }
    @deploys[ address ] = name
  end
end


def format( scribe )
 
     buf = ''

    data = _parse_tx( scribe.tx.data )

    op     = data['op']
    args   = data['data']['args']
    
    if op == 'call'
      func  = data['data']['function']
      to    = data['data']['to']
  
      contract_name = @deploys[to] ||  "???" 
   
      buf << "==> CALL #{contract_name}.#{func}    @ #{scribe.num} - #{scribe.tx.date}   (#{number_to_human_size(scribe.bytes)}) ..."
      buf << "\n"
      buf << "      to (contract): #{to}, args:"
      buf << "\n"
      buf << args.pretty_inspect
      buf << "\n"
      buf
    elsif op == 'create'
      source = data['data']['source_code']
   
      contract_names = _parse_source( source )
  
      buf << "==> CREATE #{contract_names[-1]}    @ #{scribe.num} - #{scribe.tx.date}   (#{number_to_human_size(scribe.bytes)}) ..."
      buf << "\n"
      buf << "       txid: #{scribe.id}"
      buf << "\n"
  
      deploy_rec = @deploys_by_txid[ scribe.id ]
      ## assert names are equal
      address = deploy_rec ? deploy_rec['address']  : '???'
  
      buf << "       address: #{address}"
      buf << "\n"
      buf << args.pretty_inspect
      buf << "\n"
      buf
    else
        puts "!! ERROR - unknown facet op:"
        pp data
        exit 1
    end
end

### helpers

def _parse_source( src )
    ## find all contracts - assume last is the name of the one to create!
    ## contract(:PublicMintERC20
    names = src.scan( /contract\(:([A-Z][A-Za-z0-9]*)\b/ )

    ##
    ## note: returns nested array (because of inner capture group)
    ## e.g. [["ERC20"], ["FacetSwapV1Callee"], ["FacetSwapV1ERC20"], ["IFacetSwapV1Factory"], ["Upgradeable"], ["FacetSwapV1Pair"]]
    ##      [["ERC20"], ["Upgradeable"], ["EthscriptionERC20Bridge"]]

    names.flatten   
end


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


def _parse_tx( datauri )
      ## note: datauri uses utf8 extension by default (add/use utf8: true flag)
    raw, type = DataUri.parse( datauri, utf8: true )
    unless type.start_with?( 'application/vnd.facet.tx+json' )
      puts "!! ERROR - expected application/vnd.facet.tx+json...; got:"
      puts datauri
      exit 1
    end
    data = JSON.parse( raw )
    data
end


end # class FacetPrinter