


class TypedArray < TypedReference
    
    ## todo/check: make "internal" data (array) available? why? why not?
    attr_reader :data   
 
  def initialize( initial_value = nil )
      replace( initial_value || [] )            
  end
  def zero?() @data == []; end  ## use @data.empty? - why? why not?

  def replace( new_value )  ### add/use alias assign / set / or ___ or such - why? why?
    @data = if new_value.is_a?( Typed )
               if new_value.type != type
                 raise TypeError, "expected type #{type}; got #{new_value.pretty_print_inspect}"
               end
               new_value.data
            else
                type.check_and_normalize_literal( new_value ).map do |item|
                    type.sub_type.new( item )
                end 
            end
  end
 
  ## change to ref or reference - why? why not?
  ##  or better remove completely? why? why not?
  def value
    puts "[warn] do NOT use TypedArrayg#value; will get removed? SOON?" 
    self
  end    


  ## add more Array forwards here!!!!
  ##  todo/fix:  wrap size, empty?  return value literals into typed values - why? why not?
  def_delegators :@data, :size, :length,
                         :empty?, :clear

  def []( index )
    ## use serialize to get value (why not value) - why? why not?
    index = index.is_a?( Typed ) ? index.serialize : index
  
    ## fix: use index out of bounds error - why? why not?
    raise ArgumentError, "Index out of bounds -  #{index} : #{index.class.name} >= #{@data.size}"   if index >= @data.size

    @data[ index ] || type.sub_type.new_zero
  end

  def []=(index, new_value) 
     ## use serialize to get value (why not value) - why? why not?
     index = index.is_a?( Typed ) ? index.serialize : index
 
     raise ArgumentError, "Sparse arrays are not supported"   if index > @data.size

    @data[ index ] = type.sub_type.new( new_value )
  end
  
  def push( new_value )
     @data.push( type.sub_type.new( new_value ) )
  end

  def serialize
     @data.map {|item| item.serialize } 
  end

  def pretty_print( printer ) 
    printer.text( "<ref #{type}:#{@data.pretty_print_inspect}>" ); 
  end
end  # class TypedArray

