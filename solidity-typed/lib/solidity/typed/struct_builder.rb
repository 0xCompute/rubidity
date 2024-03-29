
module Types
class Struct

  
# todo/fix:  scope: keep empty by default

def self.build_class( class_name, scope: Types, **attributes )

 ## todo/fix:
 ##    add  self.class.type  class method
 ##                returns  TypedStruct<> instance with typedef info
 ##
 ##  add name & format
 ##   e.g.  :struct (why? why not? or :tuple? if using abi names?)
 ##              tuple( types,... ) - flattend (recursive)!!! - why? why not?


 ## todo/fix:
 ## check if valid class_name MUST start with uppercase letter etc.
 ##  todo/fix: check if constant is undefined in scoped namespace!!!!

   ## map type symbols (:uint, :address, etc.)
   ##   to type for now "by hand" here

   attributes = attributes.map do |key,type|
  ##                t  =type 
                  ## t = t.type             if t.is_a?( Class ) && t.ancestors.include?( Typed )
                  [key, typeof( type )]
                end.to_h


  klass = Class.new( Struct ) do
    attributes.each do |key,type|
      define_method( key ) do
        instance_variable_get( "@#{key}" )
      end
      ## note: for Bool auto-add getter with question mark (e.g. voted? etc.)
      ##          why? why not?
      if type == BoolType.instance  
        define_method( "#{key}?" ) do
          instance_variable_get( "@#{key}" )
        end
      end
      define_method( "#{key}=" ) do |value|
        ## todo/fix:
        ## check if arg is typed && type match?
        ##  if not (assume literal) try to convert to type!!!! 

        value = if value.is_a?(Typed)
                  ## fix-fix-fix - check type match here!!!
                  value
              else 
                type.new( value )
              end

        instance_variable_set( "@#{key}", value )
      end
    end


 
    
    alias_method :old_freeze, :freeze   # note: store "old" orginal version of freeze
    define_method( :freeze ) do
      old_freeze    ## same as calling super
      attributes.keys.each do |key|
        instance_variable_get( "@#{key}" ).freeze
      end
      self   # return reference to self
    end
  end


  type = StructType.new( class_name, klass )
  klass.define_singleton_method( :type ) do
    @type ||= type       
  end

  ## add attributes (with keys / types) class method 
  klass.define_singleton_method( :attributes ) do
     attributes 
  end

  ## add self.new too - note: call/forward to "old" orginal self.new of Event (base) class
  klass.define_singleton_method( :new ) do |*args, **kwargs|
    if kwargs.size > 0  ## assume kwargs 
      ## -fix-fix-fix- check all keywords if part or struct here too!!!
      old_new( **kwargs )    
    else
      if args.empty?  ## no args - use new_zero and set (initialize) all ivars to zero
        new_zero
      else
        if args.size != attributes.size
          ## check for required args/params - all MUST be passed in!!!
          raise ArgumentError, "[Struct] wrong number of arguments for #{name}.new - #{args.size} for #{attributes.size}"
        end
        old_new( *args )
      end
    end
  end


  klass.define_singleton_method( :new_zero ) do
    values = attributes.values.map do |type|
      if type.respond_to?( :new_zero )
        type.new_zero
      else
        raise ArgumentError, "[Struct] no new_zero support for type #{type}; sorry"
      end
    end
    old_new( *values )
  end


=begin
  ## note: use Kernel for "namespacing"
  ##   make all enums convenience converters (always) global
  ##     including uppercase methods (e.g. State(), Color(), etc.) does NOT work otherwise (with other module includes)

  ## add global "Kernel" convenience converter function
  ##  e.g. Vote(0) is same as Vote.convert(0)
  Kernel.class_eval( <<RUBY )
    def #{class_name}( arg )
       #{class_name}.convert( arg )
    end
RUBY
=end

 ## note: use scoped (module) and NOT Object for namespacing
 ##   use include Safe to make all structs global
 ##  fix-fix-fix - make class_name unique across contracts (e.g. reuse same name in different contract)
  scope.const_set( class_name, klass )   ## returns klass (plus sets global constant class name)
end # method build_class



class << self
  alias_method :old_new, :new       # note: store "old" orginal version of new
  alias_method :new,     :build_class    # replace original version with create
end
  

end # class Struct
end  # module Types
