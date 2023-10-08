
module Types
class Event

  
# todo/fix:  scope: keep empty by default

def self.build_class( class_name, scope: Types, **attributes )

 ## todo/fix:
 ## check if valid class_name MUST start with uppercase letter etc.
 ##  todo/fix: check if constant is undefined in scoped namespace!!!!

   attributes = attributes.map do |key,type|
                  [key, typeof( type )]
                end.to_h


  ## note: event is a like a value type e.g. only getters
  ##         no setters (can only initialized via constructor or such)              
  klass = Class.new( Event ) do
    attributes.each do |key,type|
      define_method( key ) do
        instance_variable_get( "@#{key}" )
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


  type = EventType.new( class_name, klass )
  klass.define_singleton_method( :type ) do
    @type ||= type       
  end

  ## add attributes (with keys / types) class method 
  klass.define_singleton_method( :attributes ) do
     attributes 
  end

  ### todo/fix:
  ##    auto-add support for kwargs too!!!

  ## add self.new too - note: call/forward to "old" orginal self.new of Event (base) class
  klass.define_singleton_method( :new ) do |*args, **kwargs|
      if kwargs.size > 0   ## assume kwargs
        if kwargs.size != attributes.size
          raise ArgumentError, "[Event] wrong number of arguments for #{name}.new - #{kwargs.size} for #{attributes.size}"
        end
        ## check for matching names too - why? why not?
        if kwargs.keys.sort != attributes.keys.sort
          raise ArgumentError, "[Event] argument key (names) not matching for #{name}.new - #{kwargs.key.sort} != #{attributes.key.sort} for #{attributes.size}"
        end  
        old_new( **kwargs )
      else
        if args.size != attributes.size
          ## check for required args/params - all MUST be passed in!!!
          raise ArgumentError, "[Event] wrong number of arguments for #{name}.new - #{args.size} for #{attributes.size}"
        end
        old_new( *args )
      end
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
  

end # class Event
end  # module Types
