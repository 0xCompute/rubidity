
  def replace(new_value)
    @value = if new_value.is_a?( Typed )
               if new_value.type != type
                ## todo/check: add special handing for contracts here 
                ##                 why? why not?
                   raise TypeError, "expected type #{type}; got #{new_value.type} : #{new_value.value}"
               end
               new_value.value
            else
               type.check_and_normalize_literal( new_value )
            end
  end




def typed( type, initial_value = nil, **kwargs)   
    ## rename type to type_or_name or such - why? why not?
    return type.create( initial_value )   if type.is_a?( Type )    ## already a type(def) object

    ## check - allow strings too (onyl symbols now) - why? why not?

    ## check how to deal with :contract (only internal use) ???

    case type
    when :string                then  TypedString.new( initial_value )
    when :address               then  TypedAddress.new( initial_value ) 
    when :inscriptionId         then  TypedInscriptionId.new( initial_value )
    when :bytes32               then  TypedBytes32.new( initial_value )
    when :bytes                 then  TypedBytes.new( initial_value )
    when :bool                  then  TypedBool.new( initial_value ) 
    when :uint                  then  TypedUInt.new( initial_value )
    when :int                   then  TypedInt.new( initial_value )
    when :timestamp             then  TypedTimestamp.new( initial_value )
    when :array                 then  TypedArray.new( initial_value, **kwargs )
    when :mapping               then  TypedMapping.new( initial_value, **kwargs )
    else
      raise ArgumentError, "unknown type #{type}:#{type.class.name}; sorry"
    end
end


### note: for "legacy" use TypedVariable as legacy base - remove? SOON? why? why not?
class TypedVariable  < Typed   ## old "legacy" class for create - do NOT use  
  def self.create(  type, initial_value = nil, **kwargs ) 
     typed( type, initial_value, **kwargs ); 
  end
end # class TypedVariable





####
##  (global) convenience helper -  keep here -  why? why not?
def typedclass_to_type( typedclass )

  ## todo/check:
  ##   check for is_a?(Class) and respond_to?( type ) - why? why not?
  ##   lets you turn "plain" classes in typed (e.g. TrueClass|FalseClass, etc)

 raise ArgumentError, "typedclass expected; got #{typedclass.inspect}"  unless (typedclass.is_a?( Class ) && 
                                                                                 typedclass.ancestors.include?( Types::Typed ))
  typedclass.type
end


