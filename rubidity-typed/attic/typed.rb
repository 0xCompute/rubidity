def typed( type, initial_value = nil, **kwargs)   

  when :dumbContract          then  TypedDumbContract.new( initial_value )
  when :addressOrDumbContract then  TypedAddressOrDumbContract.new( initial_value ) 

end

class TypedValue < TypedVariable

    if type.is_a?( AddressOrDumbContractType ) &&
        (new_value.type.is_a?( AddressType ) ||
         new_value.type.is_a?( DumbContractType ))           
      new_value.value
    else
 

end


class TypedDumbContract < TypedValue
    def type() DumpContractType.instance; end  
  
    def initialize( initial_value = nil)
       replace( initial_value || type.zero )
    end 
end  # class TypedDumbContract

class TypedAddressOrDumbContract < TypedValue
    def type() AddressOrDumbContractType.instance; end  
  
    def initialize( initial_value = nil)
       replace( initial_value || type.zero )
    end 
end  # class TypedAddressOrDumbContract
