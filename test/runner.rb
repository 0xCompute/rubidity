
$LOAD_PATH.unshift( '../rubidity-typed/lib' )
$LOAD_PATH.unshift( '../rubidity/lib' )
$LOAD_PATH.unshift( '../rubidity-contracts/lib' )
require 'rubidity'
require 'rubidity/contracts'


require_relative 'contract_implementation'


alice   = '0x'+'aa'*20 # e.g. '0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
bob     = '0x'+'bb'*20 # e.g. '0xbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb'
charlie = '0x'+'cc'*20 # e.g. '0xcccccccccccccccccccccccccccccccccccccccc'

pp alice
pp bob
pp charlie



erc20receiver = ERC20Receiver.construct
pp erc20receiver.serialize


c = ERC20Minimal.construct( name: 'minimal', symbol: 'MIN', decimals: '9' )
pp c.serialize 
               





c = AddressArg.construct( testAddress: alice )
c.respond( greeting: 'hello' )
pp c.serialize




c.msg.sender = alice


receiver = Receiver.construct
pp receiver.sayHi
pp receiver.name
pp receiver._internalCall   ### FIX: mark as private with ruby too!!! why? why not?



## FIX: receiveCall uses/returns block.number!!!!!!
##  undefined method `block' 
pp receiver.receiveCall     
pp receiver.serialize


caller = Caller.construct 
pp caller


pp receiver.address


puts "contracts registry:"
pp ContractImplementation.registry



###
## todo/fix: auto-generate "global" contract lookup
##   use/delegate to   Receiver.at( address )   !!!!!!

class ContractImplementation
  def self.at( address )
    klass = self
    puts "==> calling #{klass.name}.at( #{address.pretty_print_inspect })"
    addr_key = address.is_a?( TypedAddress ) ? address.serialize : address
    rec  = ContractImplementation.registry[ addr_key ] 
    ## note: support plain strings and typed address for now
    ##   use serialize to get "raw" string value of address
    
    if rec
      obj_klass = rec[0]
      ## raise type error if not match class type
      if obj_klass == klass || obj_klass.parent_contracts.include?( klass )
        obj = rec[1]
        obj
      else
        raise TypeError, "#{obj_klass.name} contract found BUT is NOT of type #{klass.name}; sorry"
      end
    else
        nil  # nothing found
    end
  end
end



def Receiver( address )
    klass = Receiver
    puts "==> calling #{klass.name}( #{address.pretty_print_inspect })"
    obj = klass.at( address )
    raise ArgumentError, "no #{klass.name} contract @ addreess #{address} found; sorry"   if obj.nil?
    puts "  bingo! #{obj.class.name} (#{obj.class.parent_contracts}) contract found @ #{address}"
    obj
end

def ERC20( address )
    klass = ERC20
    puts "==> calling #{klass.name}( #{address.pretty_print_inspect })"
    obj = klass.at( address )
    raise ArgumentError, "no #{klass.name} contract @ addreess #{address} found; sorry"   if obj.nil?
    puts "  bingo! #{obj.class.name} (#{obj.class.parent_contracts}) contract found @ #{address}"
    obj
end  



c = Receiver( receiver.address )
pp c
pp c.class.instance_methods
pp c.class.instance_methods( false )

pp c.receiveCall
pp c.sayHi


caller.makeCall( receiver.address )
caller.callInternal( receiver.address )
caller.testImplements( erc20receiver.address )



pp AbiProxy.contract_classes


puts "bye"