

module Types
class Array < TypedReference
    
    ## todo/check: make "internal" data (array) available? why? why not?
    attr_reader :data   
 
  def initialize( initial_value = nil )
      initial_value ||= []            
      raise ArgumentError, "expected literal of type #{type}; got typed #{initial_value.pretty_print_inspect}"    if initial_value.is_a?( Typed )    
 
     @data =  type.check_and_normalize_literal( initial_value ).map do |item|
                    type.sub_type.new( item )
              end 
  end

  def zero?() @data == []; end  ## use @data.empty? - why? why not?


  extend Forwardable   ## pulls in def_delegator
  ## add more Array forwards here!!!!
  ##  todo/fix:  wrap size, empty?  return value literals into typed values - why? why not?
  def_delegators :@data, :size, :length,
                         :empty?, :clear

  def []( index )
    ## use serialize to get value (why not value) - why? why not?
    index = index.is_a?( Typed ) ? index.as_data : index
  
    ## fix: use index out of bounds error - why? why not?
    raise ArgumentError, "Index out of bounds -  #{index} : #{index.class.name} >= #{@data.size}"   if index >= @data.size

    @data[ index ] || type.sub_type.new_zero
  end

  def []=(index, new_value) 
     ## use serialize to get value (why not value) - why? why not?
     index = index.is_a?( Typed ) ? index.as_data : index
 
     raise ArgumentError, "Sparse arrays are not supported"   if index > @data.size

    @data[ index ] = type.sub_type.new( new_value )
  end
  

  def push( new_value )
     @data.push( type.sub_type.new( new_value ) )
  end

  def as_data
     @data.map {|item| item.as_data } 
  end

  def pretty_print( printer ) 
    printer.text( "<ref #{type}:#{@data.pretty_print_inspect}>" ); 
  end
end  # class Array
end  # module Types

