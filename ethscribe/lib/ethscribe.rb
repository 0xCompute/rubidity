require 'cocos'



module Ethscribe
  class Configuration

    #######################
    ## accessors
    def chain=(value)
        if value.is_a?( String ) || value.is_a?( Symbol )
            case value.downcase.to_s
            when 'mainnet'  #  'main', 'eth', 'prod', 'production'
               @chain  = 'mainnet'
               @client = Ethscribe::Api.mainnet
            when 'goerli'   #  'testnet', 'test'
               @chain = 'goerli'
               @client = Ethscribe::Api.goerli
            else
              raise ArgumentError, "unknown chain - expected mainnet | goerli; got #{value}"
            end
        else
            raise ArgumentError, "only string or symbol supported for now; sorry - got: #{value.inspect} : #{value.class.name}"
        end
    end

    def chain
      ## note - default to mainnet if not set
      self.chain = 'mainnet'   unless defined?( @chain )
      @chain
    end

    ## note: read-only for now - why? why not?
    def client
      ## note - default to btc/ if not set
      self.chain = 'mainnet'   unless defined?( @client )
      @client
    end

    def delay_in_s 
      ## note - default to 1 (sec) if not set
      self.delay_in_s = 1   unless defined?( @delay_in_s )
      @delay_in_s
    end  
    def delay_in_s=(value) @delay_in_s = value; end
    alias_method :sleep,  :delay_in_s   ## add sleep alias (or wait) - why? why not?
    alias_method :sleep=, :delay_in_s=
  end # class Configuration


  ## lets you use
  ##   Ordinals.configure do |config|
  ##      config.chain = :btc
  ##   end
  def self.configure() yield( config ); end
  def self.config()    @config ||= Configuration.new;  end

  ##  add some convenience shortcut helpers (no config. required) - why? why not?
  def self.client()      config.client; end
  def self.chain()       config.chain; end
  def self.chain=(value) config.chain = value; end


  def self.mainnet?()     config.chain == 'mainnet'; end
  def self.goerli?()      config.chain == 'goerli'; end
 

  ###################
  ### more convenience shortcuts

  def self.inscribes( **kwargs )  client.ethscriptions( **kwargs ); end
  def self.inscribe( id_or_num )  client.ethscription( id_or_num ); end
end  # module Ethscribe




## our own code
require_relative 'ethscribe/version'
require_relative 'ethscribe/api'



module Ethscribe
  #############
  ##  add more convenience alias - why? why not?
  API = Api
end  # module Ethscribe



# say hello
puts Ethscribe.banner     ## if defined?($RUBYCOCOS_DEBUG) && $RUBCOCOS_DEBUG

