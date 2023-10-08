

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
   


## our own code
require_relative 'typed/version'
require_relative 'typed/metatypes/types'
require_relative 'typed/metatypes/bool'
require_relative 'typed/metatypes/literals'
require_relative 'typed/metatypes/array'
require_relative 'typed/metatypes/mapping'


require_relative 'typed/typed'
require_relative 'typed/bool'
require_relative 'typed/values'
require_relative 'typed/numbers'

require_relative 'typed/array'
require_relative 'typed/array_builder'
require_relative 'typed/mapping'
require_relative 'typed/mapping_builder'

require_relative 'typed/struct'
require_relative 'typed/struct_builder'
require_relative 'typed/event'
require_relative 'typed/event_builder'


require_relative 'typed/enum'
require_relative 'typed/enum_builder'

require_relative 'typed/conversion'



#############
# convenience helpers

##  note: Bool is now (global) "monkey-patched" - no longer a wrapper
## TypedBool           = Types::Bool


TypedString         = Types::String
TypedAddress        = Types::Address 
TypedInscriptionId  = Types::InscriptionId
TypedBytes32        = Types::Bytes32
TypedBytes          = Types::Bytes
TypedUInt           = Types::UInt
TypedInt            = Types::Int
TypedTimestamp      = Types::Timestamp
TypedTimedelta      = Types::Timedelta

TypedArray          = Types::Array
TypedMapping        = Types::Mapping
TypedEnum           = Types::Enum
TypedStruct         = Types::Struct
TypedEvent          = Types::Event

T = Types   ## make T an alias for Types - why? why not?



####
##  (global) convenience helper to get type
##
##  use a different name 
##     e.g. typedef( obj ) or
##          typedclass_to_type( obj ) or
##           Type( obj ) or type() ??
def typeof( obj )
    ## case 1) already a metatype?
    return obj         if obj.is_a?( Types::Typed::Type )
    ## case 2a) check for (typed) class
    ##    check for Typed ancestor in class - why? why not?
    ##     e.g.    obj.ancestors.include?( Types::Typed )
    ##      2b)  Bool module
    return obj.type    if obj.instance_of?( Class ) && obj.respond_to?( :type ) 
    return obj.type    if obj == Bool   ## special case for module Bool!!!
  
##   support plain objects too here - why? why not?     
##   -- check for "plain objects"
##      return obj.class.type    if obj.class.respond_to?( :type )
    
   raise ArgumentError, "metatype or typedclass expected; got #{obj.inspect}"                                                                                 
end
  




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
