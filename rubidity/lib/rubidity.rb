
## note - rquires activesupport
##  e.g. delegate - more??
#        Array#exclude?


require 'rubidity/typed'
## replaces:
##    - type.rb
##    - typed_variable.rb
##    - array_type.rb
##    - mapping_type.rb


class HashWithIndifferentAccess   ## simple hash with indifferent acccess; symbolize keys
   def initialize( initial_value = {} )
      @data = initial_value
   end
   
   def [](key)         @data[ key.to_sym ]; end
   def []=(key, value) @data[ key.to_sym] = value; end 

   def to_hash() @data; end


   def merge( *other_hashes )
      other_hashes = other_hashes.map do |other| 
                             other.is_a?(HashWithIndifferentAccess) ? other.to_hash : other 
                      end  
      HashWithIndifferentAccess.new( @data.merge( *other_hashes ))
   end

   extend Forwardable   ## pulls in def_delegators
   def_delegators :@data,  :each, :size, 
                           :select, :key?,
                           :reduce,
                           :empty?, :==, :<=> 
end # class HashWithIndifferentAccess

class Array
def self.wrap( object )
    if object.nil?
      []
    elsif object.respond_to?(:to_ary)
      object.to_ary
    else
      [object]
    end
end
end # class Array

class String
def constantize() Object.const_get( self ); end
end  # class String



## require 'active_support/all'

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

require_relative 'rubidity/state_proxy'

require_relative 'rubidity/contract_base'
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
  





