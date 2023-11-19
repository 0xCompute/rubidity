####
# to run use:
#   $ ruby sandbox/error.rb


require_relative 'helper'


error :Unauthorized   ## custom error (global)

class TestError < Contract   
    error :InsufficientBalance, 
             available: UInt, 
             required:  UInt
    
    ## error :Unauthorized   ## custom error (local scope) -- allow overrinding - why? why not?

    storage owner: Address
   
    sig []
    def constructor
      @owner = msg.sender
    end

    sig [UInt]
    def withdraw( amount: )
        revert Unauthorized    if msg.sender != @owner

        revert InsufficientBalance,
                   available: 100,
                   required: amount    if amount > 100
  
        puts "owner.transfer(address(this).balance)"
    end
end  # class TestError

ALICE  = '0x'+'a'*40 # e.g. '0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
BOB    = '0x'+'b'*40 

pp ALICE
pp BOB


pp TestError
pp TestError.name

pp Types::Unauthorized
pp Types::Unauthorized.name


Runtime.msg.sender = ALICE
c = TestError.construct
c.withdraw( 10 )
c.withdraw( 111 )


Runtime.msg.sender = BOB
c.withdraw( 11 )


puts "bye"
  
