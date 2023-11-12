$LOAD_PATH.unshift( '../solidity-typed/lib' )
$LOAD_PATH.unshift( '../rubidity/lib' )
require 'solidity/typed'
require 'rubidity'



# move upstream - make keccak256 in contract "global" function


  ## fix-fix-fix - return a bytes32 type!!!!!!
  def keccak256( input )
    ## todo/fix: check if input is binary string 
    ##    (convert to bytes - why? why not?)
    ##    should really always use hex_to_bin !!! 
    ##    and convert the result in the end only - why? why not??
     
      typed = if input.is_a?( Types::Bytes )
                input
              else
                Types::String.new( input )
              end
  
      ## fix: convert hexdigest to binary
      '0x' + Digest::KeccakLite.hexdigest( typed.as_data, 256  )
    end
  

    def abi_encode( *args )
        ## for now simply concat strings
       val = args.join
       puts "  abi_encode: #{args.pretty_print_inspect}"
       puts "   #{val}"
       val
    end