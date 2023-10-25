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
end





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



contract = PublicMintERC20.new
pp contract

puts "bye"