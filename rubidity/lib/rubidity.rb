##
# note: for now rubidity/typed gem pulls in
#    require 'forwardable'  ## def_delegate


require 'rubidity/typed'
## replaces:
##    - type.rb
##    - typed_variable.rb
##    - array_type.rb
##    - mapping_type.rb


## our own code
require_relative 'rubidity/generator'

require_relative 'rubidity/contract_base'
require_relative 'rubidity/contract_implementation'
require_relative 'rubidity/abi_proxy'

require_relative 'rubidity/contract_transaction_globals'


##
#  add extra setup helpers


class ContractRecord    ## activerecord model class dummy 
    def initialize( type ) @type = type.name; end
    def type() @type;  end

    def current_transaction() @tx ||= Tx.new; end
    class Tx
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
    end # class Tx
end



class ContractImplementation
    def self.create

        abi = self.public_abi   ## hack: abi now used for "merged" state/events/ etc.

        puts "[debug] Contract.create  - klass -> #{self.name}"
        rec = ContractRecord.new( self )
        new( rec ) 
    end
end  # class ContractImplementation
  

