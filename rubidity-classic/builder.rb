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
   
   def function(name, args, *options, returns: nil, &body)
      @functions[ name ] = { args: args,
                            options: options,
                            returns: returns,
                            body: body }
   end
  
   def constructor(args = {}, *options, &body)
     function(:constructor, args, *options, returns: nil, &body )
   end
end  # class ContractDef




class Builder
    ## auto-add extension and import path for now - why? why not?
    def self.load_file( path )
    code = File.open( "contracts/#{path}.rb", 'r:utf-8' ) { |f| f.read }
    load( code )
  end

  def self.load( code )
    builder = Builder.new
    builder.instance_eval( code )
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
    instance_eval( code )
  end


  def contract( name, is: [], abstract: false, &body )
     contract =  ContractDef.new( name, is: is, abstract: abstract )
     contract.instance_eval( &body )

     @source.contracts << contract
  end
end  # class Builder
