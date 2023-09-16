
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
  alias_method :safe_constantize, :constantize
  def demodulize
      path = self
      path = path.to_s
      if i = path.rindex('::')
        path[(i+2)..-1]
      else
        path
      end
  end
end  # class String
class Symbol
  def constantize() to_s.constantize; end
  alias_method :safe_constantize, :constantize
  def demodulize()  to_s.demodulize; end
end  # class Symbol

=begin
def safe_constantize(camel_cased_word)
  constantize(camel_cased_word)
rescue NameError => e
  raise if e.name && !(camel_cased_word.to_s.split("::").include?(e.name.to_s) ||
    e.name.to_s == camel_cased_word.to_s)
rescue ArgumentError => e
  raise unless /not missing constant #{const_regexp(camel_cased_word)}!$/.match?(e.message)
rescue LoadError => e
  raise unless /Unable to autoload constant #{const_regexp(camel_cased_word)}/.match?(e.message)
end
=end

=begin
rubidity/abi_proxy.rb:42:in `block (2 levels) in merge_parent_abis': 
undefined method `demodulize' for "ERC20":String (NoMethodError)

        prefixed_name = "__#{parent.name.demodulize}__#{name}"
                                        ^^^^^^^^^^^
=end



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
  





