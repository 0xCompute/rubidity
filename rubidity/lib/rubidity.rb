
## note - rquires activesupport
##  e.g. delegate - more??
#        Array#exclude?


require 'rubidity/typed'
## replaces:
##    - type.rb
##    - typed_variable.rb
##    - array_type.rb
##    - mapping_type.rb


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
require_relative 'rubidity/contract_base'
require_relative 'rubidity/contract_implementation'
require_relative 'rubidity/abi_proxy'
require_relative 'rubidity/function_proxy'
require_relative 'rubidity/function_context'

require_relative 'rubidity/contract_transaction_globals'



##
#  add extra setup helpers


class ContractRecord    ## activerecord model class dummy 
    def initialize( type ) @type = type.name; end
    def type() @type;  end

    def current_transaction() @tx ||= Tx.new; end
    class Tx
      def log_event( event )
         puts "==> log_event:"
         pp event
      end
=begin
  def log_event(event)
    call_receipt.logs << event
    event
  end
=end
    end # class Tx
end



class ContractImplementation
    def self.create

        abi = self.public_abi   ## hack: abi now used for "merged" state/events/ etc.

        puts "[debug] Contract.create  - klass -> #{self.name}"
        rec = ContractRecord.new( self )
        new( rec ) 
    end
end  # class ContractImplementation
  





