
class Type

  def self.create( type_or_name, **kwargs )
    return type_or_name   if type_or_name.is_a?( Type )
  
    type_name = type_or_name.to_sym
  
    case type_name
    when :string                 then StringType.instance   ## share single (type) instance
    when :address                then AddressType.instance
    when :inscriptionId          then InscriptionIdType.instance
    when :bytes32                then Bytes32Type.instance
    when :bytes                  then BytesType.instance
    when :bool                   then BoolType.instance 
    when :uint                   then UIntType.instance 
    when :int                    then IntType.instance 
    when :timestamp              then TimestampType.instance 
    when :array
      ## todo: fix - find metadata format
      sub_type = create( kwargs[:sub_type] )  
      ArrayType.instance( sub_type )
    when :mapping 
      # e.g. mapping ({ addressOrDumbContract: :uint256 }), :public, :balanceOf    
      key_type  =  create( kwargs[:key_type] )
      value_type = create( kwargs[:value_type] )
      MappingType.instance( key_type, value_type )
    else
      raise ArgumentError, "unknown type #{type_name}; sorry"
    end    
  end



alias_method :default_value, :zero   ## keep default_value alias - why? why not?


TYPES = [:string,  
             :address, :inscriptionId,
             :bytes32, :bytes,
             :bool, 
             :uint, :int, 
             :timestamp,
             :array, :mapping]
            
             
  ## legacy - use classes e.g is_a?( ArrayType ) - why? why not?
  TYPES.each do |type|  
     define_method( "#{type}?" ) do
         ## note: must be symbols both (symbol != string!!!)
         self.name == type
     end
  end


  def self.value_types
    ## note: use shared single (type) instances
    [:string,   
     :address, :inscriptionId,
     :bytes32,
     :bytes,   ### fix: see notes on bytes - is dynamic?? (reference value) double-check!!
     :bool,
     :uint, :int, 
     :timestamp, 
    ]
  end
 
end # class Type