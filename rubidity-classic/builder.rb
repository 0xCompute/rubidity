##
# reading rubidity "dsl"
#   to generate rubidity "more-rubyish" classes


class Source   ## rename to unit (source unit) or service or ??

   attr_reader :contracts

   def initialize
      @contracts = []
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

      @functions[ name ] = { args: args,
                            options: options,
                            returns: returns,
                            body: body }
   end
  
   def constructor(args = {}, *options, &body)
     function(:constructor, args, *options, returns: nil, &body )
   end
end  # class ContractDef





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
        m[0]  ## return matched code
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
