

module Ethscribe


class Api   ## change/rename Api to Client - why? why not?
  def self.goerli
    @goerli ||= new( 'https://goerli-api.ethscriptions.com/api' )
    @goerli
  end
  ## todo: add test alias - why? why not? 

  def self.mainnet
    @mainnet ||= new( 'https://api.ethscriptions.com/api' )
    @mainnet
  end
  ## todo:  add eth, main or production alias - why? why not?


  def config() Ethscribe.config; end  ## convenience shortcut helper


  def initialize( base )
    @base          = base
    @requests      = 0  ## count requests (for delay_in_s sleeping/throttling)
  end


# 
#  Get all ethscriptions
#
#  /ethscriptions
#  
#  Query parameters: 
#   page       - integer  (starting at 1)
#   per_page   - integer    (default: 25 - max: 50)
#   sort_order - string "asc" or "desc"   (default: desc - latest first)


  def ethscriptions( page: nil, per_page: nil, sort_order: nil )  
    src = "#{@base}/ethscriptions"
    params = []
    params << ['page',       page.to_s]                    if page 
    params << ['per_page',   per_page.to_s]                if per_page 
    params << ['sort_order', sort_order.to_s.downcase ]    if sort_order
    
    if params.size > 0
         src += "?" + params.map { |key,value| "#{key}=#{URI.encode_uri_component(value)}" }.join('&')
    end

    res = get( src )
    res.json   ## return parsed json data - why? why not?
  end


  ####
  #  ContractTransaction.transaction_mimetype
  #    "application/vnd.facet.tx+json"
  #  SystemConfigVersion.system_mimetype
  #    "application/vnd.facet.system+json"
  def newer_facet_txs( new_block_number, 
                       max: 2500,
                       max_blocks: 10000,
                       count: 0 )
    newer_ethscriptions( new_block_number, 
                           max_ethscriptions: max,
                           max_blocks: max_blocks,
                           mimetypes: ['application/vnd.facet.tx+json',
                                       'application/vnd.facet.system+json'],
                           count: count
                         )
  end
  alias_method :newer_facet_txns, :newer_facet_txs

  ## add "undocumented" endpoint 
  ##   /ethscriptions/newer_ethscriptions
  ##
  ##  see https://github.com/0xFacet/facet-vm/blob/main/app/models/ethscription_sync.rb

  def newer_ethscriptions( new_block_number, 
                           max_ethscriptions: 2500,
                           max_blocks: 10000,
                           mimetypes: [],
                           count: 0
                         )
    src = "#{@base}/ethscriptions/newer_ethscriptions"

    params = []
    params << ['block_number', new_block_number.to_s]

    ## note: array MUST use rails convention with []
    mimetypes.each do |mimetype|
      params << ['mimetypes[]', mimetype]
    end

    params << ['max_ethscriptions',  max_ethscriptions.to_s] 
    params << ['max_blocks', max_blocks.to_s ] 
    params << ['past_ethscriptions_count', count.to_s]
 
    src += "?" + params.map do |key,value| 
                     "#{URI.encode_uri_component(key)}=#{URI.encode_uri_component(value)}" 
                  end.join('&')
  
    res = get( src )
    res.json   ## return parsed json data - why? why not?
  end


#  
#  Get ethscriptions owned by address
#
#  /ethscriptions/owned_by/:address
#  
#  Query parameters: page, per_page( max 1000), sort_order (asc / desc)

def ethscriptions_owned_by( address )  
  src = "#{@base}/ethscriptions/owned_by/#{address}"
 
  res = get( src )
  res.json   ## return parsed json data - why? why not?
end



#
#  Get specific ethscription
#
#  /ethscriptions/:ethscription_id
#  
#  Or
#  
#  /ethscriptions/:ethscription_number
#  
#  (ethscription_id is the transaction hash of the transaction that created the ethscription)

  # note: use singular (overload method by args not possible in ruby)
  def ethscription( id_or_num )  
    src = "#{@base}/ethscriptions/#{id_or_num}"
    res = get( src )
    res.json   ## return parsed json data - why? why not?
  end

#
#  Get data of an ethscription
#
#  /ethscriptions/:ethscription_id/data
#
# Or
#
# /ethscriptions/:ethscription_number/data
#
# This will return the ethscription's raw decoded data in the correct mimetype


  ###
  # use a struct-like content class - why? why not?
  class Content
    attr_reader :data,
                :type,
                :length
    def initialize( data, type, length )
      @data   = data
      @type   = type
      @length = length
    end

    alias_method :blob, :data
  end  ## (nested) class Content


  def ethscription_data( id_or_num )  
     src = "#{@base}/ethscriptions/#{id_or_num}/data"
     res = get( src )
 
     content_type   = res.content_type
     content_length = res.content_length

     ## note - content_length -- returns an integer (number)
     ## puts "content_length:"
     ## print content_length.inspect
     ## print " - #{content_length.class.name}\n"

      ## fix-fix-fix
      ##  if text/json/svg type etc. 
      ##  convert to utf8 (from binary blob why? why not?) - why? why not?
      ##   or add text accessor to content?

     content = Content.new(
                    res.blob,
                    content_type,
                    content_length )
     content
  end


###
# Check whether content is already ethscribed
#
# /ethscriptions/exists/:sha
# 
# Where sha is the sha256 of the UTF-8 data URI

# {"result":false,"ethscription":null}

  def ethscription_exists( sha )
    src = "#{@base}/ethscriptions/exists/#{sha}"
    res = get( src )
    res.json   ## return parsed json data - why? why not?
  end

# Determine if the indexer is behind 
#
#  {"current_block_number":18619883,"last_imported_block":18619883,"blocks_behind":0}

  def block_status
    src = "#{@base}/block_status"
    res = get( src )
    res.json   ## return parsed json data - why? why not?
  end


  def get( src )
    @requests += 1

    if @requests > 1 && config.delay_in_s
      puts "request no. #{@requests}@#{@base}; sleeping #{config.delay_in_s} sec(s)..."
      sleep( config.delay_in_s )
    end

    res = Webclient.get( src )
 
    if res.status.ok?
      res
    else
      ## todo/fix: raise exception here!!!!
      puts "!! ERROR - HTTP #{res.status.code} #{res.status.message} - failed web request >#{src}<; sorry"
      exit 1
    end
  end
end  # class Api


end   ## module Ethscibe

