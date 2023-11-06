###
# add global type conversion functions here
#
#    include via Kernel module - why? why not?


module ConversionFunctions
#####
#  todo/check:   use AddressType.try_convert( literal_or_obj ) or such - why? why not?
def address( obj )
    ## hack for now support  address(0) 
    ##  todo/fix:  address( '0x0' ) too!!!!
    return Types::Address.zero                    if obj.is_a?(::Integer) && obj == 0

    ## note: for now assume contract is always "construct"ed (and, thus, has an address assigned)
    return Types::Address.new( obj.__address__ )  if obj.is_a?( Contract )

    Types::Address.new( obj )
end  # methdod address 


def uint( obj )
    return obj.to_uint   if obj.is_a?( Types::Address )
    return obj           if obj.is_a?( Types::UInt )

    Types::UInt.new( obj )   ## assume obj is a integer number
end
alias_method :uint256, :uint
alias_method :uint224, :uint
alias_method :uint112, :uint   ## note: for now all are uint256 - fix? - why? why not?


=begin
def uint( obj=0 )
    ## check if typed?
   ## raise exception on error
end
=end



=begin  
  def string(i)
    if i.is_a?(TypedVariable) && i.type.is_value_type?
      return TypedVariable.create(:string, i.value.to_s)
    else
      raise "Input must be typed"
    end
  end
  
  def address(i)
    return TypedVariable.create(:address) if i == 0

    if i.is_a?(TypedVariable) && i.type == Type.create(:addressOrDumbContract)
      return TypedVariable.create(:address, i.value)
    end
    
    raise "Not implemented"
  end
=end

end  # module ConversionFunctions
  


Kernel.include( ConversionFunctions )
