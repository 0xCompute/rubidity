###
#  to run use:
#
#  $ ruby run_structs.rb


require_relative  '../helper'   ## use (shared) helper (boot) setup     


require_relative 'structs'


pp Todos


pp contract = Todos.construct
pp contract.serialize


pp contract.create( text: 'Vienna Waits For You') 
pp contract.create( text: 'Paris Mon Amour' ) 

pp contract.get( 0 )
pp contract.todos( 0 )

pp contract.get( 1 )
pp contract.todos( 1 )

pp contract.toggleCompleted( 0 )
pp contract.get( 0 )
pp contract.serialize

pp contract.toggleCompleted( 0 )
pp contract.get( 0 )

pp contract.updateText( 0, 'Bratislava Bratislove' )
pp contract.get( 0 )
pp contract.serialize


puts 'bye'