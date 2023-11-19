##
# to run use:
#   $ ruby sandbox/error.rb



$LOAD_PATH.unshift( "./lib" )
require 'solidity/typed'


def revert( klass, *args, **kwargs )
    raise "error class expected; got: >#{klass.inspect}<; sorry"  unless klass.ancestors.include?( Types::Error)
    
    rec = if kwargs.size > 0
            klass.new( **kwargs )
          else
            klass.new( *args )
          end
    pp rec 
end

module Sandbox

   Error.new :Unauthorized
   pp Unauthorized
   pp Unauthorized.type
   pp Unauthorized.attributes

   err = Unauthorized.new
   pp err
   pp err.serialize
   pp err.is_a?( Unauthorized )
   pp err.is_a?( Error )
   pp err.is_a?( StandardError )

   revert Unauthorized


   Error.new :InsufficientBalance, 
                available: UInt, 
                required:  UInt
   pp InsufficientBalance
   pp InsufficientBalance.type
   pp InsufficientBalance.attributes

   err = InsufficientBalance.new( available: 1, required: 100 )
   pp err
   pp err.available
   pp err.required
   pp err.serialize
   err = InsufficientBalance.new( 1, 100 )
   pp err
   pp err.available
   pp err.required
   pp err.serialize
   pp err.is_a?( InsufficientBalance )
   pp err.is_a?( Error )
   pp err.is_a?( StandardError )

   revert InsufficientBalance, available: 1, required: 100
   revert InsufficientBalance, 1, 100
end


puts 'bye'