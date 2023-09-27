##
# note: for now rubidity/typed gem pulls in
#    require 'forwardable'  ## def_delegate

##
## move require json to rubidity/typed ??
require 'json'   ##  use in public_abi_to_json



require 'digest-lite'      ### pulls in keccak256
require 'rubidity/typed'
## replaces:
##    - type.rb
##    - typed_variable.rb
##    - array_type.rb
##    - mapping_type.rb


## our own code
require_relative 'rubidity/version'
require_relative 'rubidity/generator'

require_relative 'rubidity/contract_base'
require_relative 'rubidity/contract_implementation'
require_relative 'rubidity/abi_proxy'

require_relative 'rubidity/runtime'


##
#  add extra setup helpers

class ContractImplementation

    def self.construct( *args, **kwargs )
      ## todo/fix: check either args or kwargs MUST be empty
      ##   can only use one format
      puts "[debug] Contract.construct  - class -> #{self.name}"
      puts "           args: #{args.inspect}"      unless args.empty?
      puts "           kwargs: #{kwargs.inspect}"  unless kwargs.empty?

      contract = new
      
      ## (auto-)register before or after calling constructor  - why? why not?
      contract.__autoregister__
 
      contract.constructor( *args, **kwargs )
      contract
    end
    ## note: create is only an alias for construct !!!!
    ##         to create an empty contract to load with state use new!!!
    class << self
      alias_method :create, :construct
    end
end  # class ContractImplementation


puts Rubidity::Module::Lang.banner     ## say hello
