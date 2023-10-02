

require 'forwardable'  ## def_delegate


##
###  add more erros - why? why not?
class ValueError < StandardError; end
## if type is ok, but value of type not in range (e.g. uint with negative numbers)
##    or maybe enum out-of-range - why? why not? 





## forward declare contract base (from rubidity)
##    for type checking
class ContractBase 
end
   

#######
##   global constants
STRING_ZERO          = ''.freeze             ## string with utf-8 encoding 
BYTES_ZERO           = String.new().freeze   ## string with binary encoding
BYTES20_ZERO         = ('0x'+'00'*20).freeze   ## 20 bytes (40 hexchars)  ## care about string encoding here - why? why not?
BYTES32_ZERO         = ('0x'+'00'*32).freeze   ## 32 bytes (64 hexchars)

ADDRESS_ZERO         = BYTES20_ZERO
INSCRIPTION_ID_ZERO  = INSCRIPTIONID_ZERO = BYTES32_ZERO

##
# note:
#  use class Typed as namespace  for metatypes e.g. Type, StringType, AddressType,
#     the idea is to avoid confusion about metatypes and typed classes
#           by "hiding" metatypes from top-level (inside typed)
class Typed; end



## our own code
require_relative 'typed/version'
require_relative 'typed/metatypes'
require_relative 'typed/typed'
require_relative 'typed/typed_values'
require_relative 'typed/typed_numbers'

require_relative 'typed/typed_array'
require_relative 'typed/typed_array_builder'
require_relative 'typed/typed_mapping'
require_relative 'typed/typed_mapping_builder'

require_relative 'typed/typed_struct'
require_relative 'typed/typed_struct_builder'

require_relative 'typed/typed_enum'
require_relative 'typed/typed_enum_builder'

require_relative 'typed/conversion'




##
# convenience helpers

TypedBool           = Types::Bool
TypedString         = Types::String
TypedAddress        = Types::Address 
TypedInscriptionId  = Types::InscriptionId
TypedBytes32        = Types::Bytes32
TypedBytes          = Types::Bytes
TypedUInt           = Types::UInt
TypedInt            = Types::Int
TypedTimestamp      = Types::Timestamp

TypedArray          = Types::Array
TypedMapping        = Types::Mapping
TypedEnum           = Types::Enum
TypedStruct         = Types::Struct

T = Types   ## make T an alias for Types - why? why not?



# "sandbox helper"
 module Sandbox
  include Types
 end
#
## use like:
##   module Sandbox
##           str = String.new
##           Array‹String› = Array.new( String )
##           ary = Array‹String›.new
##           ...
##
##     to access "old/classic" string or array use:
##        str = ::String.new
##        ary = ::Array.new
##   end


puts Rubidity::Module::Typed.banner    ## say hello
