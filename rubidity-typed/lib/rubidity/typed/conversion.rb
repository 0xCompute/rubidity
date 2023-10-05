###
# add global type conversion functions here
#
#    include via Kernel module - why? why not?


module ConversionFunctions
#####
#  todo/check:   use AddressType.try_convert( literal_or_obj ) or such - why? why not?
def address( literal=ADDRESS_ZERO )
    ## hack for now support  address(0) 
    ##  todo/fix:  address( '0x0' ) too!!!!
    literal = ADDRESS_ZERO     if literal.is_a?(::Integer) && literal == 0
    Types::Typed::AddressType.instance.check_and_normalize_literal( literal )
end  # methdod address 


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
