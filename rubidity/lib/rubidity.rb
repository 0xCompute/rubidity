##
# note: for now rubidity/typed gem pulls in
#    require 'forwardable'  ## def_delegate

##
## move require json to rubidity/typed ??
require 'json'   ##  use in public_abi_to_json


require 'rubidity/typed'
## replaces:
##    - type.rb
##    - typed_variable.rb
##    - array_type.rb
##    - mapping_type.rb


## our own code
require_relative 'rubidity/generator'

require_relative 'rubidity/contract_base'
require_relative 'rubidity/contract_implementation'
require_relative 'rubidity/abi_proxy'

require_relative 'rubidity/runtime'


##
#  add extra setup helpers

class ContractImplementation
    def self.create
        puts "[debug] Contract.create  - class -> #{self.name}"
        new 
    end

    def self.construct( *args, **kwargs )
      ## todo/fix: check either args or kwargs MUST be empty
      ##   can only use one format
      puts "[debug] Contract.construct  - class -> #{self.name}"
      puts "           args: #{args.inspect}"      unless args.empty?
      puts "           kwargs: #{kwargs.inspect}"  unless kwargs.empty?

      contract = create
      contract.constructor( *args, **kwargs )
      contract
    end
end  # class ContractImplementation
  
