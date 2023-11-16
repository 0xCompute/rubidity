###
#  to run use:
#
#  $ ruby run_enum.rb


require_relative  '../helper'   ## use (shared) helper (boot) setup     


require_relative 'enum'


pp EnumBasic


pp contract = EnumBasic.construct
pp contract.serialize


pp contract.get
pp contract.set( 1 )
pp contract.get
pp contract.set( 2 )

pp contract.cancel
pp contract.serialize

pp contract.reset
pp contract.serialize


puts 'bye'