####
# to run use:
#   $ ruby sandbox/diagram.rb


$LOAD_PATH.unshift( './lib' )
require 'facetq'


require 'yaml'


config = YAML.load_file( './database.yml' )


puts "Connecting to db using settings: "
pp config['development']
ActiveRecord::Base.establish_connection( config['development'] )



## Now hand over to rails-erd
require 'rails_erd/diagram'

class YumlDiagram < RailsERD::Diagram

  setup do
    @edges = []
  end

  each_relationship do |relationship|
    line = if relationship.indirect? then "-.-" else "-" end

    arrow = case
    when relationship.one_to_one?   then "1#{line}1>"
    when relationship.one_to_many?  then "1#{line}*>"
    when relationship.many_to_many? then "*#{line}*>"
    end

    @edges << "[#{relationship.source}] #{arrow} [#{relationship.destination}]"
  end

  save do
    puts @edges.join("\n")
  end
end

YumlDiagram.create


puts "bye"



__END__

[Ethscription] 1-1> [SystemConfigVersion]
[ContractTransaction] 1-*> [ContractArtifact]
[Ethscription] 1-1> [ContractTransaction]
[ContractTransaction] 1-1> [TransactionReceipt]
[ContractTransaction] 1-*> [ContractState]
[ContractTransaction] 1-*> [ContractCall]
[ContractTransaction] 1-*> [Contract]
[Contract] 1-*> [ContractState]
[Ethscription] 1-*> [ContractState]
[Contract] 1-*> [ContractCall]
[Ethscription] 1-*> [ContractCall]
[Ethscription] 1-*> [Contract]
[Contract] 1-.-1> [TransactionReceipt]
[EthBlock] 1-*> [TransactionReceipt]
[Ethscription] 1-1> [TransactionReceipt]
[EthBlock] 1-*> [Ethscription]