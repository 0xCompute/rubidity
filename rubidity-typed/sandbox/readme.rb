
$LOAD_PATH.unshift( "./lib" )
require 'rubidity/typed'


#####################################
#   frozen (immutable ) value types


## note: (typed) strings always use utf-8 encoding AND
##               are frozen/immutable!!!
pp a = TypedString.new
pp a = TypedString.new( "hello, world!" )


pp a = TypedUint256.new    
pp a = TypedUint256.new(100)   
pp a += 100
pp a -= 100

## use/add TypedNat(ural) (natural integer number) alias - why? why not?
##   check if natural numbers start at 0 (or exclude 0 ????)

pp a = TypedInt256.new
pp a = TypedInt256.new( 100 )
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


pp a = TypedEthscriptionId.new
pp a = TypedEthscriptionId.new( '0x'+'ab'*32 )


pp a = TypedBytes32.new
pp a = TypedBytes32.new( '0x'+'ab'*32 )


pp a = TypedDatetime.new
## use/change/rename to Timestamp - why? why not?
##   ALWAYS uses epoch time starting at 0 (no time zone or such)



###
## todo/check:  is bytes a (mutabale)bytebuffer or a frozen/immutable?
pp a = TypedBytes.new    

__END__


###########################
### reference types

pp a = TypedArray.new( sub_type: :string )
pp a.type
pp a = TypedArray.new( ['zero', 'one', 'two'], sub_type: :string )
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

pp a = TypedArray.new( sub_type: :uint256 )
pp a.type
pp a = TypedArray.new( [0,1,2], sub_type: :uint256 )
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

pp a = TypedMapping.new( key_type: :address, value_type: :uint256 )
pp a.type
pp a = TypedMapping.new( { alice   =>  100,
                        bob     =>  200 },
                       key_type: :address, value_type: :uint256 )

pp a[ alice ]
pp a[ bob ]
pp a[ charlie ]      
pp a[ charlie ] = 300
pp a[ charlie ]      
pp a.serialize



puts "bye"