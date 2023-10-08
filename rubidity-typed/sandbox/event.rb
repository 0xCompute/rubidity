##
# to run use:
#   $ ruby sandbox/event.rb



$LOAD_PATH.unshift( "./lib" )
require 'rubidity/typed'


def log( klass, *args, **kwargs )
    raise "event class expected; got: >#{klass.inspect}<; sorry"  unless klass.ancestors.include?( Types::Event)
    
    rec = if kwargs.size > 0
            klass.new( **kwargs )
          else
            klass.new( *args )
          end
    pp rec 
end


module Sandbox
   Event.new :Transfer, from:   Address, 
                        to:     Address, 
                        amount: UInt

   pp Transfer
   pp Transfer.type
   pp Transfer.attributes

   Event.new :Approval,  owner: Address, 
                         spender: Address, 
                         amount:  UInt 

   pp Approval
   pp Approval.type
   pp Approval.attributes

   rec = Transfer.new( address(0), address(0),  111 )
   pp rec
   pp rec.from
   pp rec.to
   pp rec.amount
   pp rec.serialize

   log Transfer, address(0), address(0), 111
   log Transfer, from: address(0), 
                 to: address(0), 
                 amount: 111

                 
   ## try mixed-up key order               
   log Approval, amount: 333, 
                 spender: address(0),
                 owner: address(0) 
                  
                
end 


puts 'bye'