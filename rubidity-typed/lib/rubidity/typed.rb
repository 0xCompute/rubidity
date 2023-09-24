

require 'forwardable'  ## def_delegate


## forward declare contract base (from rubidity)
##    for type checking
class ContractBase 
end
   
## our own code
require_relative 'typed/version'
require_relative 'typed/types'
require_relative 'typed/typed'
require_relative 'typed/typed_array'
require_relative 'typed/typed_mapping'



#####
#  todo/check:   use AddressType.try_convert( literal_or_obj ) or such - why? why not?
def address( literal='0' )
    ## hack for now support  address(0) 
    ##  todo/fix:  address( '0x0' ) too!!!!
    literal = ADDRESS_ZERO     if literal.is_a?(Integer) && literal == 0
    AddressType.instance.check_and_normalize_literal( literal )
end  # methdod address 
  


puts Rubidity::Module::Typed.banner    ## say hello