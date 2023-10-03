###
#  to run use:
#
#  $ ruby run_counter.rb


require_relative  '../helper'   ## use (shared) helper (boot) setup     


require_relative 'counter'


pp Counter


pp contract = Counter.construct
pp contract.serialize

pp contract.get
pp contract.inc
pp contract.inc
pp contract.inc
pp contract.dec


pp contract2 = Counter.construct
pp contract2.serialize

pp contract2.get
pp contract2.inc


puts 'bye'
