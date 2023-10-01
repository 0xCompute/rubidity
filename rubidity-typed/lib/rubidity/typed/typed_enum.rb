###############################
## base class for enum
#
#
#  notes on enum:
#    do NOT ever create new typed enums with new/create!!!!
#        only create zeros with new_zero!!!!!
#     otherwise always reuse and assign CONSTANTS!!!!
##
##  todo - fix-fix-fix - enforce rules in code here - why? why not?
##              make new private or such - why? why not?
##                          check TrueClass|FalseClass as example - why? why not?

## for bool and enum
##   use TypedData  - only allow assignment of existing instances
##                            no NEW possible!!!
##                     thus - deserialize has a switch for TypedData!!

class TypedEnum  < Typed

  ## return a new Enum read-only class
  attr_reader :key
  attr_reader :value

  def initialize( key, value, warn: true )
    raise ArgumentError, "enum #{self.class.name} - do NOT call new EVER; reuse existing enum members! sorry"  if warn

    @key   = key
    @value = value
    self.freeze   ## make "immutable"
    self
  end

  def self._typecheck_enum!( o )
    if o.instance_of?( self )
      o
    else
      raise TypeError.new( "[enum] enum >#{name}< type expected; got >#{o.class.inspect}<" )
    end
  end
  def _typecheck_enum!( o ) self.class._typecheck_enum!( o ); end


  def ==( other )
    if other.is_a?( Integer ) && other == 0   ## note: only allow compare by zero (0) integer - why? why not?
      @value == 0
    else
      @value == _typecheck_enum!( other ).value
    end
  end
  ##   keep eql?  compare by object_id(entity) - why? why not?
  ### alias_method :eql?, :==


  def self.keys
    @keys ||= members.map {|member| member.key}.freeze
    @keys
  end

  def self.key( key )
    ## note: returns nil now for unknown keys
    ##   use/raise IndexError or something - why? why not?
    @hash_by_key ||= Hash[ keys.zip( members ) ].freeze
    @hash_by_key[key]
  end

  class << self
    alias_method :[], :key    ## convenience alias for key
  end

  def self.values
    @values ||= members.map {|member| member.value}.freeze
    @values
  end

  def self.value( value )
    ## note: returns nil now for unknown values
    ##   use/raise IndexError or something - why? why not?
    @hash_by_value ||= Hash[ values.zip( members ) ].freeze
    @hash_by_value[value]
  end

  def self.min()  members[0]; end
  def self.max()  members[-1]; end

  def self.zero() members[0]; end
  def zero?() self == self.class.zero; end  ## note: use compare by identity (object_id) and NOT value e.g. 0

  ## fix - fix -fix: add min and max  too!!!!

  def self.size() keys.size; end
  class << self
    alias_method :length, :size   ## alias (as is the ruby tradition)
  end

  def self.convert( arg )
    ## todo/check: support keys too - why? why not?
    ## e.g. Color(0), Color(1)
    ##      Color(:red), Color(:blue) - why? why not?
    ## note: will ALWAYS look-up by (member) index and NOT by value (integer number value might be different!!)
    members[ arg ]
  end

  ## add to_i, to_int - why? why not?
  def to_i()       @value; end
  def to_int()     @value; end      ## allows Integer( .. )

  ## add to_b/to_bool support (see safebool @ https://github.com/s6ruby/safebool) - why? why not?  
  # def parse_bool() @value != 0; end   ## nonzero == true, zero == false like numbers


   def serialize() @value; end
   def replace( new_value )
      raise ArgumentError, "(abstract) data type;  CANNOT replace - MUST assign a new data member reference; sorry"
   end

  def pretty_print( printer ) 
    printer.text( "<val #{type}:#{@key}(#{@value})>" ); 
  end
end  # class Enum
