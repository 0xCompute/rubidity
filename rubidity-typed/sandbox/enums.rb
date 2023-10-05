##
# to run use:
#   $ ruby sandbox/enums.rb



$LOAD_PATH.unshift( "./lib" )
require 'rubidity/typed'

## Enum.new( :Color, :red, :green, :blue )


module Sandbox

    Color = Enum.new( :Color, :red, :green, :blue )
pp Color
pp Color::RED
pp Color.red
## pp Color.red?

pp Color::GREEN
pp Color.green
## pp Color.green?


pp Color.values  
pp Color.keys
pp Color.members

pp Color.zero
pp Color.min
pp Color.max

pp Color.convert( 0 )
pp Color.convert( 1 )
pp Color.convert( 99 )



color = Color.new_zero
pp color
color = Color.green
pp color

type = Color.type
pp type
pp type.new_zero
pp type.new( 0 )
pp type.new( 1 )
pp type.new( 2 )

## pp type.new( 4 )  -- returns nil!!!! (throw exception - why? why not?)

############
#
#   enum :ActionChoices :GoLeft, :GoRight, :GoStraight, :SitStill
 
ActionChoices = Enum.new( :ActionChoices, 
                            :goLeft, :goRight, :goStraight, :sitStill )

pp ActionChoices
pp ActionChoices.values  
pp ActionChoices.keys
pp ActionChoices.members

pp ActionChoices.zero
pp ActionChoices.min
pp ActionChoices.max

pp ActionChoices.goLeft
pp ActionChoices.goRight

puts 'bye'

end # module sandbox 