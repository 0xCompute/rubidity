
$LOAD_PATH.unshift( "./lib" )
require 'rubidity/typed'


#####################################
#   frozen (immutable ) value types


## note: (typed) strings always use utf-8 encoding AND
##               are frozen/immutable!!!
pp a = TypedString.new
pp a = TypedString.new( "hello, world!" )


pp a = TypedUInt.new    
pp a = TypedUInt.new(100)   
pp a += 100
pp a -= 100

## use/add TypedNat(ural) (natural integer number) alias - why? why not?
##   check if natural numbers start at 0 (or exclude 0 ????)

pp a = TypedInt.new
pp a = TypedInt.new( 100 )
pp a += 100
pp a -= 100

##
## idea  - use "plain" integer as TypedInt - why? why not?


pp a  = TypedBool.new
pp a  = TypedBool.new( true )

##
## idea - use "plain" true|false  as TypedBool (frozen|typed)


pp a = TypedAddress.new
pp a = TypedAddress.new( '0x'+ 'aa'*20 )


pp a = TypedInscriptionId.new
pp a = TypedInscriptionId.new( '0x'+'ab'*32 )


pp a = TypedBytes32.new
pp a = TypedBytes32.new( '0x'+'ab'*32 )


pp a = TypedTimestamp.new
## use/change/rename to Timestamp - why? why not?
##   ALWAYS uses epoch time starting at 0 (no time zone or such)



###
## todo/check:  is bytes a (mutabale)bytebuffer or a frozen/immutable?
pp a = TypedBytes.new    




###########################
### reference types

TypedArray‹TypedString› = TypedArray.build_class( TypedString )
pp TypedArray‹TypedString›.type

pp a = TypedArray‹TypedString›.new
pp a = TypedArray‹TypedString›.new( ['zero', 'one', 'two'] )
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

TypedArray‹TypedUInt› = TypedArray.build_class( TypedUInt )
pp TypedArray‹TypedUInt›.type


pp a = TypedArray‹TypedUInt›.new
pp a = TypedArray‹TypedUInt›.new( [0,1,2] )
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


TypedMapping‹TypedAddress→TypedUInt› = TypedMapping.build_class( 
                                                      TypedAddress,
                                                      TypedUInt )

pp TypedMapping‹TypedAddress→TypedUInt›.type


pp a = TypedMapping‹TypedAddress→TypedUInt›.new
pp a = TypedMapping‹TypedAddress→TypedUInt›.new( { alice   =>  100,
                                                   bob     =>  200 } )

pp a[ alice ]
pp a[ bob ]
pp a[ charlie ]      
pp a[ charlie ] = 300
pp a[ charlie ]      
pp a.serialize


puts "bye"