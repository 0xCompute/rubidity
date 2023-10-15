module Types
class Typed  ## note: use class Typed as namespace (all metatype etc. nested here - the beginning)


    
## todo - break-up literal_norm  and move into types - why? why not?
class Type

  def raise_type_error(literal)
    ## change to typeerror or such - why? why not?
    raise TypeError, "expected type #{self.format}; got #{literal.inspect}"
  end


  def parse_integer(literal)
    base = literal.start_with?( '0x' ) ? 16 : 10
    
    begin
      Integer(literal, base)
    rescue ArgumentError 
      raise_type_error( literal )
    end
  end


  def check_and_normalize_literal( literal )
     ### todo/check - split up and move to type classes - why? why not?

## fix fix fix:  allow typed passed in as literals here?
##    if literal.is_a?(TypedVariable)
##     raise TypeError, "Only literals can be passed to check_and_normalize_literal: #{literal.inspect}"
##    end


    if is_a?(AddressType)
 ##  fix fix fix: add contract support     
 #     if literal.is_a?(ContractType::Proxy)
 #       return literal.address
 #     end
 
      unless literal.is_a?(::String) && literal.match?(/\A0x[a-f0-9]{40}\z/i)
        raise_type_error(literal)
      end
      
      ## note: always downcase & freeze address - why? why not?
      return literal == ADDRESS_ZERO ? literal : literal.downcase.freeze
    elsif is_a?( ContractType )  
      ## elsif is_contract_type?
      ##   uses in original. 
      ##     def is_contract_type?
      ##       ContractImplementation.valid_contract_types.include?(name)
      ##     end
    
      ## todo/check - use a different base class for contracts - why? why not?
      ##   fix fix fix: check matching contract type/class too - why? why not?
       if literal.is_a?( Contract )
         return literal
       else
         raise TypeError, "No literals allowed for contract types  got: #{literal}; sorry"
       end
 

    elsif is_a?(UIntType)
      if literal.is_a?(::String)
        literal = parse_integer(literal)
      end
        
      if literal.is_a?(::Integer) && literal.between?(0, 2 ** 256 - 1)
        return literal
      end
      
      raise_type_error(literal)
    elsif is_a?( IntType )
      if literal.is_a?(::String)
        literal = parse_integer(literal)
      end
        
      if literal.is_a?(::Integer) && literal.between?(-2 ** 255, 2 ** 255 - 1)
        return literal
      end
      
      raise_type_error(literal)
    elsif is_a?( EnumType )
       if literal.is_a?( ::Integer )  ## todo - check literal is withing min/max
          return literal
       end
       raise_type_error(literal)
    elsif is_a?( StringType )
      unless literal.is_a?( ::String)
        raise_type_error(literal)
      end
      
      return literal.freeze
    elsif is_a?( BoolType )
      ## fix-fix-fix- check if solidity support 0|1 for bools in function args???
      unless literal == true || literal == false
        raise_type_error(literal)
      end
      
      return literal
    elsif is_a?( InscriptionIdType ) || is_a?( Bytes32Type )
      unless literal.is_a?( ::String) && literal.match?(/\A0x[a-f0-9]{64}\z/i)
        raise_type_error(literal)
      end

      ## note: always downcase & freeze address - why? why not?
      ##   fix-fix-fix - check - use BYTES32_ZERO - why? why not?
      return literal == INSCRIPTION_ID_ZERO ? literal : literal.downcase.freeze

    elsif is_a?( BytesType )
      ## note:  assume empty string is bytes literal!!!
      if literal.is_a?( ::String) && literal.length == 0
        return literal
      end
      
      unless literal.is_a?( ::String) && 
              literal.match?(/\A0x[a-fA-F0-9]*\z/)  && 
              literal.size.even?
        raise_type_error( literal )
      end
      
      ##
      ##  check if dynamic? (like bytebuffer) - freeze? why? why not?
      return literal.downcase


    elsif is_a?( TimestampType ) || is_a?( TimedeltaType )
      dummy_uint = UIntType.instance
      
      begin
        return dummy_uint.check_and_normalize_literal(literal)
      rescue TypeError   ## TypeError => e
        raise_type_error(literal)
      end
    elsif is_a?( MappingType )
      if literal.is_a?( TypedMapping)   ## todo - check if possible (literal) typed mapping
        return literal    
      end
 
      unless literal.is_a?(Hash)
        raise_type_error(literal)
      end
      
      ## add types (wrap literal in types)
      ## todo - do a quick check - if hash populated with vars - why? why not?
      ## todo/fix: check for nested arrays/mappings!!!
      ##    do NOT wrap in SafeMapping/SafeArray
      data = literal.map do |key, value|
        [
          key_type.check_and_normalize_literal( key ),
          value_type.check_and_normalize_literal( value )
        ]
      end.to_h

      return data
    elsif is_a?( ArrayType )  
      
      ## todo/fix: check for matching sub_type!!!!
      ## check if possible to get TypedArray passed in as literal!!!
      if literal.is_a?(TypedArray)
        return literal    ## .data   ## note: return nested (inside) data e.g. array!!!
      end
      
      unless literal.is_a?(::Array)
        raise_type_error(literal)
      end
      
      ## check types only - wrap literal in types - why? why not?
      data = literal.map do |value|
        sub_type.check_and_normalize_literal( value )
      end

      return data    
    end


    raise TypeError, "invalid type; expected #{self.format}; got #{literal.inspect}"
  end


end  # class Type    


end  # class Typed  ## note: use class Typed as namespace (all metatype etc. nested here - the beginning)
end  #  module Types
    