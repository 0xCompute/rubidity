




class TypedArray < TypedReference
    
    ## todo/check: make "internal" data/array available? why? why not?
    attr_reader :data   


   def initialize( value = nil, sub_type: )
    @type = Type.create( :array, sub_type: sub_type )
    unless @type.sub_type.is_value_type?
      raise ArgumentError, "Only value types for array elements supported for now; sorry" 
    end

    replace( value || [] )            
  end
  def zero?() @data == []; end  ## use @data.empty? - why? why not?


  def replace( new_value )  ### add/use alias assign / set / or ___ or such - why? why?
    @data = if new_value.is_a?( TypedVariable )
               if new_value.type != @type
                 raise TypeError, "expected type #{type}; got #{new_value.type} : #{new_value.value}"
               end
               new_value.data
            else
                type.check_and_normalize_literal( new_value ).map do |item|
                    @type.sub_type.create( item )
                end 
            end
  end
  ## change to ref or reference - why? why not?
  ##  or better remove completely? why? why not?
  def value()
    puts "[warn] do NOT use TypedArray#value; will get removed? SOON?" 
    self
  end    
  def value=(new_value) 
    puts "[warn] do NOT use TypedArray#value=(new_value); will get removed? SOON?" 
    replace( new_value ) 
  end

  ## add more Array forwards here!!!!
  extend Forwardable   ## pulls in def_delegator
  def_delegators :@data, :size, :empty?, :clear,
                          :map, :reduce 

  def []( index )
    ## fix: use index out of bounds error - why? why not?
    raise ArgumentError, "Index out of bounds"   if index >= @data.size

    @data[ index ] || @type.sub_type.create
  end

  def []=(index, new_value) 
    raise ArgumentError, "Sparse arrays are not supported"   if index > @data.size

    @data[ index ] = @type.sub_type.create( new_value )
  end
  
  def push( new_value )
     @data.push( @type.sub_type.create( new_value ) )
  end

  ## note: pass through value!!!!
  ##   in new scheme - only "plain" ruby arrays/hash/string/integer/bool used!!!!
  ##    no wrappers!!! - no need to convert!!!

  def serialize
     @data.map {|item| item.serialize } 
  end
end  # class TypedArray

