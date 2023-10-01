

require 'forwardable'  ## def_delegate


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
require_relative 'typed/typed_array'
require_relative 'typed/typed_array_builder'
require_relative 'typed/typed_mapping'
require_relative 'typed/typed_mapping_builder'

require_relative 'typed/typed_struct'
require_relative 'typed/typed_struct_builder'

require_relative 'typed/typed_enum'
require_relative 'typed/typed_enum_builder'

require_relative 'typed/conversion'





puts Rubidity::Module::Typed.banner    ## say hello