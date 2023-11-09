## todo/ find a better name - why? why not?
##   change to Blockchain/Chain/Node/Client/Runner/Ctx/Context or ??? 
class Runtime   


  class Message
    attr_reader :sender
    
    def sender=(address)
      ## note: allow literal and typed address
      @sender = address.is_a?( Types::Address) ?
                    address : Types::Address.new( address )
    end
  end   # class Message
  

  class Tx 
    attr_reader :origin
    def origin=(address)
      @origin = address.is_a?( Types::Address ) ?
                   address : Types::Address.new( address )
    end

      def log_event( event )
         puts "==> log_event:"
         pp event
      end
=begin
  def log_event(event)
    call_receipt.logs << event
    event
  end
=end
  end  # class Tx
  

  class Block
    attr_accessor :number, :timestamp
    
    # def initialize(current_transaction)
    #   @current_transaction = current_transaction
    # end
    
    def blockhash( block_number )
      ##
      # unless @current_transaction.ethscription.block_number == block_number.value # TODO FIX
      #  raise "Not implemented"
      # end
      # 
      # @current_transaction.ethscription.block_blockhash

      # todo - check what ("dummy") to return here??
    end
    
    def number=(number)
      @number =    number.is_a?( Types::UInt ) ? 
                      number : Types::UInt.new( number )
    end
    
    def timestamp=(timestamp)
      @timestamp =  timestamp.is_a?( Types::Timestamp ) ?
                        timestamp : Types::Timestamp.new( timestamp )
    end
  end   # class Block



  def self.msg()   @msg    ||= Message.new; end
  def self.block() @block  ||= Block.new; end     


  ## use begin_transaction or
  ##     new_transaction or  __ - why? why not?
  def self.start_transaction()   @tx = Tx.new; end
  def self.current_transaction() @tx ||= Tx.new; end

  class << self
    alias_method :start_tx,   :start_transaction
    alias_method :current_tx, :current_transaction
  end
end  # class Runtime   

