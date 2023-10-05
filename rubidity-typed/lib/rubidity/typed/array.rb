

module Types
class Array < TypedReference
    
    ## todo/check: make "internal" data (array) available? why? why not?
    attr_reader :data   
 
  def initialize( initial_value = [] )
      ## was: initial_value ||= []
      ##     check if nil gets passed in - default not used?  
      raise ArgumentError, "expected literal of type #{type}; got typed #{initial_value.pretty_print_inspect}"    if initial_value.is_a?( Typed )    
 
     @data =  type.check_and_normalize_literal( initial_value ).map do |item|
                    type.sub_type.new( item )
              end 

      ## check size if fixed (must all set to zero up to size!!!)         
      if type.size > 0  ## auto-init with zeros
         if @data.size >= type.size  ## note: allow ("fixed") array to grow bigger for now - why? why not?
            # bingo! already setup with inital values
         else
            self.size = type.size
         end
      end     
  end


  def zero?() 
      ## fix-fix-fix  - add support for fixed Array here or use a new class - why? why not?
      @data == []  ## use @data.empty? - why? why not?   
  end  


  extend Forwardable   ## pulls in def_delegator
  ## add more Array forwards here!!!!
  ##  todo/fix:  wrap size, empty?  return value literals into typed values - why? why not?
  def_delegators :@data, :size, :length,
                         :empty?

  def []( index )
    ## use serialize to get value (why not value) - why? why not?
    index = index.is_a?( Typed ) ? index.as_data : index
  
    ## fix: use index out of bounds error - why? why not?
    raise ArgumentError, "Index out of bounds -  #{index} : #{index.class.name} >= #{@data.size}"   if index >= @data.size

    obj = @data[ index ] 
    if obj.nil?  
      obj = type.sub_type.new_zero
      @data[ index ] = obj
    end
    obj
  end
 
  def []=(index, new_value) 
     ## use serialize to get value (why not value) - why? why not?
     index = index.is_a?( Typed ) ? index.as_data : index
 
     raise ArgumentError, "Sparse arrays are not supported; index out of bounds - sorry"   if index >= @data.size

     # fix-fix-fix: allow typed value here (not only literals)!!!
     obj = if new_value.is_a?( Typed ) 
               new_value
           else
               type.sub_type.new( new_value )
           end
  
     @data[ index ] = obj
  end
  

  def pop
     ## note: pop will decrease size/lenght!!!
     ## will remove LAST item in array!!!
     ##
     ## Pop is used to delete or remove an element 
     ##   in a dynamic array from the end.
     @data.pop
  end

  def push( new_value )
     ## note: push will increase size/length!!!
     ##
     ## Push is used to add new element to a dynamic array,
     ##  when you push a value to an array, it becomes the last value
     obj = if new_value.is_a?( Typed ) 
               new_value
           else
               type.sub_type.new( new_value )
           end
     @data.push( obj )

     ## note: returns array.size (NOT array itself!!!) to keep compatible with solidity - why? why not?
     @data.size
  end


  def delete( index )
    ## note sets the element to zero!!!
    ##  will NOT remove from array itself!!!
  
    ## use serialize to get value (why not value) - why? why not?
    index = index.is_a?( Typed ) ? index.as_data : index
  
    ## fix: use index out of bounds error - why? why not?
    raise ArgumentError, "Index out of bounds -  #{index} : #{index.class.name} >= #{@data.size}"   if index >= @data.size

    @data[ index ] = type.sub_type.new_zero
    self
  end


  def size=( new_size )
    ## todo/check: value must be greater 0 and greater than current size
    diff = new_size - @data.size
    if diff == 0
      ## stay as is; do nothing
    elsif diff > 0
      ## todo/check:
      ##    always return (deep) frozen zero object - why? why not?
      ##     let user change the returned zero object - why? why not?
      if type.sub_type.respond_to?( :new_zero )
        ## note: use a new unfrozen copy of the zero object
        ##    changes to the object MUST be possible (new "empty" modifable object expected)
        diff.times { @data << type.sub_type.new_zero }
      else
         raise "[Array]#length= cannot create new_zero for type #{type.sub_type} - sorry"
      end
    else  ## diff < 0
      ## fix-fix-fix - raise error here - cannot shrink/delete via length!!!
    end
    self  # return reference to self
  end
  alias_method :length=, :size=   ## always use length (and remove size?) - why? why not?


  def clear
    ## note: reset ary to zero  (NOT empty e.g. [])
    ##         differes for "fixed" size arrays
    @data.clear
    self.size = type.size   if type.size > 0  ## auto-init with zeros
    self  # return reference to self
  end


  def as_data
     @data.map {|item| item.as_data } 
  end

  def pretty_print( printer ) 
    printer.text( "<ref #{type}:#{@data.pretty_print_inspect}>" ); 
  end
end  # class Array
end  # module Types

