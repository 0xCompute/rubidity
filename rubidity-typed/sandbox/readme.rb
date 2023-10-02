
$LOAD_PATH.unshift( "./lib" )
require 'rubidity/typed'


module Sandbox

#####################################
#   frozen (immutable ) value types


## note: (typed) strings always use utf-8 encoding AND
##               are frozen/immutable!!!
pp a = String.new
pp a = String.new( "hello, world!" )


pp a = UInt.new    
pp a = UInt.new(100)   
pp a += 100
pp a -= 100

## use/add TypedNat(ural) (natural integer number) alias - why? why not?
##   check if natural numbers start at 0 (or exclude 0 ????)

pp a = Int.new
pp a = Int.new( 100 )
pp a += 100
pp a -= 100

##
## idea  - use "plain" integer as TypedInt - why? why not?


pp a  = Bool.new
pp a  = Bool.new( true )

##
## idea - use "plain" true|false  as TypedBool (frozen|typed)


pp a = Address.new
pp a = Address.new( '0x'+ 'aa'*20 )


pp a = InscriptionId.new
pp a = InscriptionId.new( '0x'+'ab'*32 )


pp a = Bytes32.new
pp a = Bytes32.new( '0x'+'ab'*32 )


pp a = Timestamp.new
## use/change/rename to Timestamp - why? why not?
##   ALWAYS uses epoch time starting at 0 (no time zone or such)



###
## todo/check:  is bytes a (mutabale)bytebuffer or a frozen/immutable?
pp a = Bytes.new    




###########################
### reference types

Array‹String› = Array.build_class( String )
pp Array‹String›.type

pp a = Array‹String›.new
pp a = Array‹String›.new( ['zero', 'one', 'two'] )
pp a[0]
pp a[1]
pp a[2]
pp a.length
pp a.push( 'three' )
pp a[3]
pp a[4] = 'four'
pp a[4]
pp a.length
pp a.serialize


## todo/check:  add a "convenience" TypedStringArray or TypedArray<String>
##                 use special unicode-chars for <>??

Array‹UInt› = Array.build_class( UInt )
pp Array‹UInt›.type


pp a = Array‹UInt›.new
pp a = Array‹UInt›.new( [0,1,2] )
pp a[0]
pp a[1]
pp a[2]
pp a.length
pp a.push( 3 )
pp a[3]
pp a[4] = 4
pp a[4]
pp a.length
pp a.serialize


## todo/check:  add a "convenience" TypedUintArray or TypedArray<Uint>
##                 use special unicode-chars for <>??


alice   = '0x'+ 'aa'*20
bob     = '0x'+ 'bb'*20
charlie = '0x'+ 'cc'*20


Mapping‹Address→UInt› = Mapping.build_class( Address, UInt )

pp Mapping‹Address→UInt›.type


pp a = Mapping‹Address→UInt›.new
pp a = Mapping‹Address→UInt›.new( { alice   =>  100,
                                    bob     =>  200 } )

pp a[ alice ]
pp a[ bob ]
pp a[ charlie ]      
pp a[ charlie ] = 300
pp a[ charlie ]      
pp a.serialize


puts "bye"


end  # module Sandbox
