###
#  to run use:
#
#  $ ruby run_arrays.rb


require_relative  '../helper'   ## use (shared) helper (boot) setup     


require_relative 'arraybasic'


pp ArrayBasic


pp contract =  ArrayBasic.construct
pp contract.serialize

pp contract.push( 1 )
pp contract.push( 2 )
pp contract.push( 3 )

pp contract.get( 0 )
pp contract.get( 1 )
pp contract.get( 2 )


pp contract.getArr()


pp contract.getLength()
pp contract.pop()
pp contract.pop()

pp contract.getLength()


pp contract.examples()
#=> <ref uint[5]:[<val uint:0>, 
#                 <val uint:0>, 
#                 <val uint:0>, 
#                 <val uint:0>, 
#                 <val uint:0>]>


pp contract.remove( 0 )
pp contract.push( 44 )
pp contract.remove( 1 )



require_relative 'arrayremovebyshifting'

pp ArrayRemoveByShifting

pp contract =  ArrayRemoveByShifting.construct
pp contract.serialize

pp contract.test()
pp contract.serialize





require_relative 'arrayreplacefromend'

pp ArrayReplaceFromEnd

pp contract =  ArrayReplaceFromEnd.construct
pp contract.serialize

pp contract.test()
pp contract.serialize


puts 'bye'
