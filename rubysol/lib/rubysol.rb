##
# note: for now rubidity/typed gem pulls in
#    require 'forwardable'  ## def_delegate

##
## move require json to rubidity/typed ??
require 'json'   ##  use in public_abi_to_json



require 'digest-lite'      ### pulls in keccak256
require 'hexutils'         ### pulls in hex/to_hex (decode/encode_hex)
require 'solidity/typed'




## define global Array()  and Mapping(,)  helpers
##     to  generate types
##   or add upstream TypedArray() and TypedMapping(,) 
##    and add alias here for Array(), Mapping(,) - why? why not? 

def array( sub_type, size=0 ) 
    typedclass = Types::Array.new( sub_type, size )
    typedclass   
end

def mapping( key_type, value_type ) 
    typedclass = Types::Mapping.new( key_type, value_type )
    typedclass
end




## add "namespaced" convenience / shortcut names for Typed<Type> classes
##   note use ::String for "standard" string and such!!!
class Contract

   include Types
=begin   
   String          = TypedString
   Address         = TypedAddress
   InscriptionId   = TypedInscriptionId
   Bytes32         = TypedBytes32
   Bytes           = TypedBytes
   Bool            = TypedBool
   UInt            = TypedUInt
   Int             = TypedInt
   Timestamp       = TypedTimestamp
=end
   ## todo/check - what to do about  TypedArray and Typed Mapping
   ##                 requires/uses mapping() and array for now
   ##
   ##     Array   = TypedArray
   ##     Mapping = TypedMapping ??
   ##      and (Typed)Array.of(  UInt ) or (Typed)Array.of( String )
   ##      and (Typed)Mapping.of( Address, UInt) or ...
   ## Array           = TypedArray
   ## Mapping         = TypedMapping
   ##
   ## puts "check alias are same?"
   ## pp String   == TypedString    #=> true!!
   ## pp String   === TypedString   #=> false!!!!!!!
   ## pp Address  == TypedAddress    #=> true
   ## pp Address  === TypedAddress   #=> false!!!!!
   ##  note: use org class name; alias via === compare WILL FAIL!!!
   ## note:  case/when/ will NOT work; use if/elsfi/else!!!
end # class Contract
 


## our own code
require_relative 'rubysol/version'
require_relative 'rubysol/generator'

require_relative 'rubysol/contract/crypto'
require_relative 'rubysol/contract/runtime'
require_relative 'rubysol/contract'
require_relative 'rubysol/abi_proxy'

require_relative 'rubysol/library'   ## add support for libaries


require_relative 'rubysol/runtime'


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



puts Rubysol::Module::Lang.banner     ## say hello
