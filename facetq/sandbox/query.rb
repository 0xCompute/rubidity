####
# to run use:
#   $ ruby -I ./lib sandbox/query.rb

require 'facetq'

require 'yaml'


config = YAML.load_file( './database.yml' )


puts "Connecting to db using settings: "
pp config['development']
ActiveRecord::Base.establish_connection( config['development'] )




puts "  #{EthBlock.count} block(s)"
puts "  #{Ethscription.count} ethscription(s)"
puts "  #{TransactionReceipt.count} receipt(s)"

puts "  #{ContractArtifact.count} contract artifact(s)"
puts "  #{Contract.count} contract(s)"
puts "  #{ContractTransaction.count} contract transaction(s)"
puts "  #{ContractCall.count} contract call(s)"
puts "  #{ContractState.count} countract state(s)"

puts "  #{SystemConfigVersion.count} system config version(s)"






data = EthBlock.order(:block_number).limit(1)
pp data

puts 
pp data.as_json


data = TransactionReceipt.limit(1)
pp data

puts 
pp data.as_json


puts "bye"

