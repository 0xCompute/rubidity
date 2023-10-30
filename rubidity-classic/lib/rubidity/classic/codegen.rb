#####
#  codegen - code generator

##
## require(s.balanceOf[msg.sender] >= amount, 'Insufficient balance')
##    
## s.balanceOf[msg.sender] -= amount
## s.balanceOf[to] += amount
## 
## emit :Transfer, from: msg.sender, to: to, amount: amount

def patch( src )
    ## change require() to assert
    src = src.gsub( /\brequire\b/, 'assert' )
 
    ## s. to ivars (@)
    src = src.gsub( /\bs\./, '@' )
 
    ## change emit :  to log
    src = src.gsub( /\bemit[ ]+:/, 'log ' )
    src
end
 
 

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
  when :bool    then Bool   ## note: Bool is always "global" - why? why not?
  when :mapping then mapping( spec_to_type( spec[:key_type] ), 
                              spec_to_type( spec[:value_type] ) )
  else
    raise ArgumentError, "unknown type - #{spec[:type]}" 
  end
end



##
#  use static methods for now  - why? why not?
class CodegenClassic

   
def self.generate( source )
    pp source

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

        input_types = function_args[:args].values.map { |type| spec_to_type(type) } 
      
        kwargs  = function_args[:args].keys.map {|arg| "#{arg}:" }.join( ', ' )
        puts "  kwargs: #{kwargs}"
        body    = function_args[:body]
        body    = patch( body )  ## use ruby-ish conventions
      

        if function_name == :constructor 
          puts "==> add constructor..."
          contract_class.sig input_types
          ## add unsafe method
          
          code =<<RUBY
            def constructor( #{kwargs} ) 
               puts "==> calling #{contract_class.name}.constructor..."
               puts "  self: \#{self.class.name}"
               #{body}
            end
RUBY
          puts "  code:"
          puts code
          contract_class.class_eval( code )
        else
           ## fix-fix-fix:  single type for now or nil
           returns = function_args[:returns]
           output_type = returns ? spec_to_type( returns ) : nil
 
           puts "==> add #{function_name}..."
           contract_class.sig input_types, returns: output_type
           ## add unsafe method

           code =<<RUBY
           def #{function_name}( #{kwargs} ) 
              puts "==> calling #{contract_class.name}.#{function_name}..."
              puts "  self: \#{self.class.name}"
              #{body}
           end
RUBY
         puts "  code:"
         puts code
         contract_class.class_eval( code )
        end
    end
end
end # method self.generate

end # class CodegenClassic

