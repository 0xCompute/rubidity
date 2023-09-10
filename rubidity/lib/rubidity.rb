
## note - rquires activesupport
##  e.g. delegate - more??
#        Array#exclude?


require 'rubidity/typed'
## replaces:
##    - type.rb
##    - typed_variable.rb
##    - array_type.rb
##    - mapping_type.rb




require 'active_support/all'

# module Enumerable
# def exclude?(object) !include?(object); end
# end # module Enumerable

# class Object
# def blank?() 
# def present?() !blank?; end
# end # class Object

## require 'forwardable'  ## def_delegate
## require 'json'


## our own code
require_relative 'rubidity/contract_errors'

require_relative 'rubidity/state_variable'
require_relative 'rubidity/state_proxy'

require_relative 'rubidity/contract_implementation'
require_relative 'rubidity/abi_proxy'
require_relative 'rubidity/function_context'

require_relative 'rubidity/contract_transaction_globals'



##
#  add extra setup helpers

class ContractRecord    ## activerecord model class dummy 
    def initialize( type ) @type = type.name; end
    def type() @type;  end
end

class ContractImplementation
    def self.create
        puts "klass -> #{self.name}"
        rec = ContractRecord.new( self )
        new( rec ) 
    end
end  # class ContractImplementation
  





