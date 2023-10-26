require_relative 'builder'


source = Builder.load_file( 'PublicMintERC20' ).source
pp source



####################
### generate contract classes

pp source.contracts

puts "  #{source.contracts.size} contract(s):"
source.contracts.each do |contract|
    print "   #{contract.name}"
    print " is #{contract.is.inspect}"   unless contract.is.empty?
    print "\n"
end



$LOAD_PATH.unshift( '../rubidity/lib' )
require 'rubidity'

## "built-in" types by "classic" symbol lookup

   ## storage decimals{:type=>:uint8, :args=>[:public]}
    ## storage totalSupply{:type=>:uint256, :args=>[:public]}
    ## storage balanceOf{:type=>:mapping, :key_type=>:address, :value_type=>:uint256, :args=>[:public]}
    ## storage allowance{:type=>:mapping,
    ##                   :key_type=>:address,
    ##   :value_type=>{:type=>:mapping, :key_type=>:address, :value_type=>:uint256, :args=>[]},
 
def spec_to_type( spec )
  type = spec.is_a?( Symbol ) ? spec : spec[:type] 
  case type  
  when :uint8   then Types::UInt
  when :uint256 then Types::UInt
  when :address then Types::Address
  when :string  then Types::String
  when :mapping then mapping( spec_to_type( spec[:key_type] ), 
                              spec_to_type( spec[:value_type] ) )
  else
    raise ArgumentError, "unknown type - #{spec[:type]}" 
  end
end

###
#  hack: allow function body (block) lookup in contract
#   
class Contract  
  def self.functions
    @functions ||= {}
  end
end   # class Contract      



contract_classes = {}  ## lookup by name

source.contracts.each do |contract|
    puts "==> generate contract #{contract.name}..."
    base =  contract.is.empty? ? Contract : contract_classes[contract.is[0]]
    puts "  base: #{base}"
    pp contract.is

    contract_class = Class.new( base )

    ## Use Kernel / global ?? scope for now
    scope = Object
    scope.const_set( contract.name, contract_class )
    contract_classes[ contract.name ] = contract_class

    ## add events if any
    ##
    ## event :Transfer, { from: :address, to: :address, amount: :uint256 }
    ## event :Approval, { owner: :address, spender: :address, amount: :uint256 }
    ##
    ## event Transfer {:from=>:address,  :to=>:address,      :amount=>:uint256}
    ## event Approval {:owner=>:address, :spender=>:address, :amount=>:uint256}
    contract.events.each do |event_name, event_args|
        print "event #{event_name}"
        pp event_args

        attributes = event_args.map { |name, type| [name, spec_to_type(type)] }.to_h 
        pp attributes
        contract_class.event( event_name, **attributes ) 
    end

    ## add storage/state if any
    ##
    ## storage name{:type=>:string, :args=>[:public]}
    ## storage symbol{:type=>:string, :args=>[:public]}
    ## storage decimals{:type=>:uint8, :args=>[:public]}
    ## storage totalSupply{:type=>:uint256, :args=>[:public]}
    ## storage balanceOf{:type=>:mapping, :key_type=>:address, :value_type=>:uint256, :args=>[:public]}
    ## storage allowance{:type=>:mapping,
    ##                   :key_type=>:address,
    ##   :value_type=>{:type=>:mapping, :key_type=>:address, :value_type=>:uint256, :args=>[]},
    ##    :args=>[:public]}
    contract.storage.each do |storage_name, storage_args|
        print "storage #{storage_name}"
        pp storage_args
 
        kwargs = {
            storage_name => spec_to_type( storage_args )
        }
        contract_class.storage( **kwargs ) 
    end


    ## add functions if any
    ## constructor:
    ##  {:args=>{:name=>:string, :symbol=>:string, :decimals=>:uint8},
    ##   :options=>[],
    ##   :returns=>nil,
    ##   :body=>#<Proc:0x0000023162c23ce8 (eval):17>}
    ## function approve:
    ##  {:args=>{:spender=>:address, :amount=>:uint256},
    ##   :options=>[:public, :virtual],
    ##   :returns=>:bool,
    ##   :body=>#<Proc:0x0000023162c23a18 (eval):23>}
    ## function transfer:
    ##  {:args=>{:to=>:address, :amount=>:uint256},
    ##   :options=>[:public, :virtual],
    ##   :returns=>:bool,
    ##   :body=>#<Proc:0x0000023162c236f8 (eval):31>}
    contract.functions.each do |function_name, function_args|
        print "function #{function_name}"
        pp function_args
        
        if function_name == :constructor 
          puts "==> add constructor..."
          input_types = function_args[:args].values.map { |type| spec_to_type(type) } 
          contract_class.sig input_types
          ## add unsafe method
          
          kwargs  = function_args[:args].keys.map {|arg| "#{arg}:" }.join( ', ' )
          args    = function_args[:args].keys.join( ', ' )
          puts "  kwargs: #{kwargs}"
          puts "  args: #{args}"
          contract_class.functions[function_name] = function_args[:body]

          code =<<RUBY
            def constructor( #{kwargs} ) 
               puts "==> calling #{contract_class.name}.constructor..."
               puts "  self: \#{self.class.name}"
               instance_exec( *[#{args}], &#{contract_class.name}.functions[:#{function_name}] )
            end
RUBY
          puts "  code:"
          puts code
          contract_class.class_eval( code )

          # contract_class.define_method( function_name ) do |**kwargs|
          #   ## todo/fix: assume kwargs order SAME as args -fix-fix-fix-
          #    instance_exec( *kwargs.values, &body )
          # end
        else
   
        end
    end
end


##
# handle methods with **kwargs (only) e.g.
#   [[:keyrest, :kwargs]]
#  keys:
#    [:kwargs]




#############
#  try out contract classes

pp ERC20
pp PublicMintERC20

pp ERC20.name
pp PublicMintERC20.name


pp ERC20::Transfer   ## {:from=>:address,  :to=>:address,      :amount=>:uint256}
pp ERC20::Approval   ## {:owner=>:address, :spender=>:address, :amount=>:uint256}
pp ERC20::Transfer.name 
pp ERC20::Approval.name

pp ERC20::Transfer.new( from: address(0), to: address(0), amount: 0)
pp ERC20::Approval.new( owner: address(0), spender: address(0), amount: 0)




contract = ERC20.new
pp contract
contract.constructor( name: 'My Fun Token',
                      symbol: 'FUN',
                      decimals: 18 )

pp contract

contract.__ERC20__constructor( name: 'My Fun Token',
                               symbol: 'FUN',
                               decimals: 18 )
pp contract



contract = PublicMintERC20.new
pp contract
## pp PublicMintERC20.instance_methods( :false )


contract.__ERC20__constructor( name: 'My Fun Token',
                               symbol: 'FUN',
                               decimals: 18 )
pp contract



## try call constructor
##  [debug] add sig args: [Types::String, Types::String, Types::UInt, Types::UInt, Types::UInt], opti

puts
puts "==========="

contract.constructor( name: 'My Fun Token',
                      symbol: 'FUN',
                      maxSupply: 21000000,
                      perMintLimit: 10000,
                      decimals: 18 )
pp contract


puts "bye"