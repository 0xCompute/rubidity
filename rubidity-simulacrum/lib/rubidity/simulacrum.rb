
require 'rubidity'

###
## our own code
require_relative 'simulacrum/version'


class Simulacrum    ## make it an module - why? why not?

     include Types    ## pulls in Address, UInt, etc.

     class Message

        # puts "==> defined?"
        # puts defined?( Address )
        # puts defined?( UInt )
        # puts defined?( InscriptionId )

        attr_reader :sender
        attr_reader :value     
        def sender=( address )
          ## check - why Address not accessible here?
          @sender = Types::Address.new( address )
        end
        def value=( value )
          ## check - why UInt not accessible here?
          @value = Types::UInt.new( value )
        end
      end # (nested) class Message


      class Block
        attr_accessor :number, :timestamp
                
        def blockhash( block_number )
             ## check what to return here???
        end
        
        def number=(number)
          ## check - why UInt not accessible here?
          @number = Types::UInt.new( number )
        end
        
        def timestamp=(timestamp)
          @timestamp = Types::Timestamp.new( timestamp )
        end
      end

    def self.msg()   @msg    ||= Message.new; end
    def self.block() @block  ||= Block.new; end     
    
###
# send_transaction/transct
   class Receipt
      attr_accessor :contract, :logs
      def initialize( contract: nil,
                      logs: [] )
         @contract = contract
         @logs     = logs             
      end
   end            


    def self.send_transaction( from:, 
                               to: Typed::ADDRESS_ZERO,
                               data: [], 
                               value: 0 )
        ## setup transaction "context"                       
        msg.sender = from
        msg.value  = value
        ## up tx counter (nonce/number used once)
        Account[ from ].nonce += 1   

       if to == Typed::ADDRESS_ZERO && data.is_a?( Class )  ## contract creation
           ## todo/fix: allow constructor args
           ##  check (data.is_a?(Array) && data[0].is_a?(Class)
           klass = data
           contract = klass.new
           contract.constructor

           Receipt.new( contract: contract )
       else
           ## note: for now assume to is always a contract instance
           contract = to
           if data.empty?  ## assume default receive!!!
              contract.receive
              Receipt.new
           else
              ## to be done
              ## contract.send
           end
       end
    end
    class << self
        alias_method :transact, :send_transaction 
    end
end  # class Simulacrum


###
# add convience shortcut/hand
Sim    = Simulacrum
Simula = Simulacrum


###
# (monkey) patch  - by simply replace (overwrite) - built-in msg && block  
#                                                    to use Simulacrum!!!

class Contract
  def msg()    Simulacrum.msg; end
  def block()  Simulacrum.block; end
end


###
# add accounts machinery

module Types
class Address
## add ethereum account "magic" e.g. balance (getter), send (method), transfer (method)
  
  def _account
     ## get "attached" account - make private? why? why not
     Account[ @value ]
  end

  def balance()  _account.balance;  end

  def send( value )
     ## note: always use simple string in account lookup!!!
     from =  Account[ Simulacrum.msg.sender.as_data ]    
     to   =  _account

     ## check for more datatypes or (simply) use to_int or to_i - why? why not?
     value = value.is_a?( UInt ) ? value.as_data : value

     ## check for below 0 - why? why not?        
     if value > from.balance
        raise ArgumentError, "insufficent funds - account has #{from.balance} and required min. #{value}; sorry"
     end 

     from.balance -= value
     to.balance   += value
  end

  ## check - transfer same as send (but with different rollback/error exception policy?)
  def transfer( value ) send( value ); end  
end  ## class Address
end  # module Types



class Account
  def self.registry
    @@registry ||= {} 
  end

  def self.[]( address )
    registry[ address ] ||= Account.new( address )
  end

  def self.all()  registry.values; end  


  attr_accessor :balance, :nonce
  attr_reader   :address

  def initialize( address )
    @address = address
    @balance = 0
    @nonce   = 0   ## count transactions (via nonce - number used once) - why? why not?
  end


  def pretty_print( printer ) 
     printer.text( "#<account #{@address[0,6]}...#{@address[34,6]} @balance=#{@balance.inspect}, @nonce=#{@nonce.inspect}" ); 
  end 
end  # class Account





puts Rubidity::Module::Simulacrum.banner    ## say hello
