

### use a differet name? why? why not?
##     e.g CryptoFunctons or ...

module CryptoHelper     
###
#  Digest::KeccakLite.new( 256 ).hexdigest( 'abc' )   # or
#  Digest::KeccakLite.hexdigest( 'abc', 256 )
#  #=> "4e03657aea45a94fc7d47ba826c8d667c0d1e6e33a64a036ec44f58fa12d6c45"  


  ## fix-fix-fix - return a bytes32 type!!!!!!
  def keccak256( input )
  ## todo/fix: check if input is binary string 
  ##    (convert to bytes - why? why not?)
  ##    should really always use hex_to_bin !!! 
  ##    and convert the result in the end only - why? why not??

    str = Types::String.new( input )

    ## fix: convert hexdigest to binary
    '0x' + Digest::KeccakLite.hexdigest( str.as_data, 256  )
  end


end  # module CryptoHelper