##
# reading rubidity "dsl"
#   to generate rubidity "more-rubyish" classes


class Source   ## rename to unit (source unit) or service or ??

   attr_reader :contracts

   def initialize
      @contracts = []
   end

   def generate
      GeneratorClassic.generate( self )
   end
end  # class Source



class ContractDef
   attr_reader :name, :is, :abstract, 
               :events, :storage, :functions
   def initialize( name, is: [], abstract: false )
      @name      = name
      @is        = if is.is_a?( Symbol ) 
                        [is]
                   elsif is.is_a?( Array ) 
                         is   
                   else
                     raise ArgumentError, "symbol or array expected; got #{is.inspect}"
                   end
      @abstract  = abstract
      @events    = {}
      @storage   = {}
      @functions = {}
   end 


   def event( name, args )
      @events[name] = args
   end

   [:string, :uint8, :uint256,].each do |type|
     define_method(type) do |*args|
        type = type
        name = args.pop.to_sym
        @storage[ name ] = { type: type, args: args }
     end
   end

   def mapping( *args )
        key_type, value_type = args.shift.first
        
        if args.last.is_a?( Symbol )
          name = args.pop
          @storage[ name ] = { type: :mapping, 
                               key_type: key_type, 
                               value_type: value_type,
                               args: args } 
        else
           { type: :mapping, 
             key_type: key_type, 
             value_type: value_type,
             args: args }
        end
   end
   

   def function(name, args, *options, returns: nil, &body )
      ## check if access to source is possible?
      puts 
      # puts "   function body: #{body.class.name}"
      #=>  Proc
      # body.soure
      #=> ["(eval)", 17]  - source filename and line number
      pp body
      pp body.parameters
      pp body.source_location
      puts
      puts  body.source 

      source = patch( body.source )  ## use ruby-ish conventions
      puts
      puts source

      @functions[ name ] = { args: args,
                            options: options,
                            returns: returns,
                            body: source }
   end
  
   def constructor(args = {}, *options, &body)
     function(:constructor, args, *options, returns: nil, &body )
   end
end  # class ContractDef


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




class Proc
  ## add quick & dirty support for getting source!!!  

  ## use non-greed .*? to "slurp"-up everything to the end
  BLOCK_RX = /do 
               .*? 
              \n[ ]{0,2}end
              /xm

  def source
     filename, lineno = self.source_location
     lines = File.open( "contracts/#{filename}.rb", 'r:utf-8' ) { |f| f.readlines }
     ## up to 10 for now
     ## note: lineno is starting counting at 1 (use -1 for offset in ary)

     ## for now assume no method longer than 100 lines
     ## note: lines INCLUDEs newlines e.g.
     ##  ["  constructor(name: :string, symbol: :string, decimals: :uint8) do |name, symbol, decimals|\n",
     ##   "    puts \"ERC20.constructor\"\n",
     ##   "    @name = name\n",
     ##   "    @symbol = symbol\n",
     ##   "    @decimals = decimals\n",
     ##   "  end\n",

     pastie = lines[lineno-1, 100].join
     ## pp pastie
     
     ## use regex quick hack
     ##   to extract use first do
     ##  and end on its own line (with max indent of two spaces!!)
     m = BLOCK_RX.match( pastie )
     if m
        m[0][2..-1][0..-4]  ## return matched code - cut of do/end wrapper
     else
        raise  "sorry; no do-end match for code block source"
     end 
  end  
end



class Builder
    ## auto-add extension and import path for now - why? why not?
    def self.load_file( path )
    code = File.open( "contracts/#{path}.rb", 'r:utf-8' ) { |f| f.read }
    basename = File.basename( path )
    lineno   = 1
    load( code, basename, lineno )
  end

  ## note: try adding filename and lineno to get source for block!!!
  def self.load( code, filename, lineno )
    builder = Builder.new
    builder.instance_eval( code, filename, lineno )
    builder
  end

  def initialize
    @source = Source.new
  end

  attr_reader :source


  ## examples:
  ## pragma :rubidity, "1.0.0"
  def pragma( ... )
     ## ignore for now
  end

  ## examples:
  ## import './ERC20'
  def import( path )
    puts "==> importing >#{path}<..."
    code = File.open( "contracts/#{path}.rb", 'r:utf-8' ) { |f| f.read }
  
    basename = File.basename( path )
    lineno   = 1  ## note: starting at line 1 (NOT 0!!!)
    instance_eval( code, basename, lineno )
  end


  def contract( name, is: [], abstract: false, &body )
     contract =  ContractDef.new( name, is: is, abstract: abstract )
     contract.instance_eval( &body )

     @source.contracts << contract
  end
end  # class Builder



#####
# code generator

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
  when :bool    then Bool   ## note: Bool is always "global" - why? why not?
  when :mapping then mapping( spec_to_type( spec[:key_type] ), 
                              spec_to_type( spec[:value_type] ) )
  else
    raise ArgumentError, "unknown type - #{spec[:type]}" 
  end
end



##
#  use static methods for now  - why? why not?
class GeneratorClassic

   
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

end # class GeneratorClassic


