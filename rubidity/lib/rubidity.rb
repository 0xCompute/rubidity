##
# note: for now rubidity/typed gem pulls in
#    require 'forwardable'  ## def_delegate

##
## move require json to rubidity/typed ??
require 'json'   ##  use in public_abi_to_json



require 'digest-lite'      ### pulls in keccak256
require 'rubidity/typed'
## replaces:
##    - type.rb
##    - typed_variable.rb
##    - array_type.rb
##    - mapping_type.rb



####
##  move upstream to rubidity-typed - why? why not?
def typedclass_to_type( typedclass )
  raise ArgumentError, "typedclass expected; got #{typedclass.inspect}"  unless (typedclass.is_a?( Class ) && 
                                                                                 typedclass.ancestors.include?( Typed))

  ## puts "check alias are same?"
  ## pp String   == TypedString    #=> true!!
  ## pp String   === TypedString   #=> false!!!!!!!
  ## pp Address  == TypedAddress    #=> true
  ## pp Address  === TypedAddress   #=> false!!!!!
  ##  note: use org class name; alias via === compare WILL FAIL!!!
  ## note:  case/when/ will NOT work; use if/elsfi/else!!!

  if    typedclass == TypedString         then StringType.instance
  elsif typedclass == TypedAddress        then AddressType.instance
  elsif typedclass == TypedInscriptionId  then InscriptionIdType.instance
  elsif typedclass == TypedBytes32        then Bytes32Type.instance
  elsif typedclass == TypedBytes          then BytesType.instance
  elsif typedclass == TypedBool           then BoolType.instance
  elsif typedclass == TypedUInt           then UIntType.instance
  elsif typedclass == TypedInt            then IntType.instance
  elsif typedclass == TypedTimestamp      then TimestampType.instance
  else
    raise ArgumentError, "no type configured for typedclass #{typedclass.inspect}; sorry"
  end
end


class TypedArray
  def self.of( sub_type )
    ## todo/fix:   use ArrayType.instance( sub_type ) - why? why not?
    type = Type.create(:array, 
                   sub_type: sub_type.is_a?( Type ) ? sub_type : typedclass_to_type( sub_type ))
    type
  end
end

class TypedMapping
  def self.of( key_type, value_type )
      ## note: support nested array or mapping type in value type!!!!
      ## todo//fix: use MappingType.instance( key_type, value_type ) - why? why not?
      type = Type.create( :mapping, 
               key_type:   typedclass_to_type( key_type ), 
               value_type: value_type.is_a?( Type ) ? value_type :typedclass_to_type( value_type ))
      type
  end
end

## "old" array and mapping helpers - why? why not?  
def array( sub_type ) TypedArray.of( sub_type ); end
def mapping( key_type, value_type ) TypedMapping.of( key_type, value_type ); end



## add "namespaced" convenience / shortcut names for Typed<Type> classes
##   note use ::String for "standard" string and such!!!
class ContractBase
   String          = TypedString
   Address         = TypedAddress
   InscriptionId   = TypedInscriptionId
   Bytes32         = TypedBytes32
   Bytes           = TypedBytes
   Bool            = TypedBool
   UInt            = TypedUInt
   Int             = TypedInt
   Timestamp       = TypedTimestamp
   ## todo/check - what to do about  TypedArray and Typed Mapping
   ##                 requires/uses mapping() and array for now
   ##
   ##     Array   = TypedArray
   ##     Mapping = TypedMapping ??
   ##      and (Typed)Array.of(  UInt ) or (Typed)Array.of( String )
   ##      and (Typed)Mapping.of( Address, UInt) or ...
   Array           = TypedArray
   Mapping         = TypedMapping
end
 

## our own code
require_relative 'rubidity/version'
require_relative 'rubidity/generator'

require_relative 'rubidity/contract_base'
require_relative 'rubidity/contract'
require_relative 'rubidity/abi_proxy'

require_relative 'rubidity/runtime'


##
#  add extra setup helpers

class Contract

    def self.construct( *args, **kwargs )
      ## todo/fix: check either args or kwargs MUST be empty
      ##   can only use one format
      puts "[debug] Contract.construct  - class -> #{self.name}"
      puts "           args: #{args.inspect}"      unless args.empty?
      puts "           kwargs: #{kwargs.inspect}"  unless kwargs.empty?

      contract = new
      
      ## (auto-)register before or after calling constructor  - why? why not?
      contract.__autoregister__
 
      contract.constructor( *args, **kwargs )
      contract
    end
    ## note: create is only an alias for construct !!!!
    ##         to create an empty contract to load with state use new!!!
    class << self
      alias_method :create, :construct
    end
end  # class Contract



puts Rubidity::Module::Lang.banner     ## say hello
