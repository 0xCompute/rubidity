# minitest setup
require 'minitest/autorun'


class MiniTest::Test
  def self.test( name, &block )
    test_name = "test_#{name.downcase.gsub(/\s+/, '_').gsub( /[^a-z0-9_]+/, '')}".to_sym
    defined = method_defined?( test_name )
    raise "#{test_name} is already defined in #{self}" if defined
   
    define_method( test_name, &block)
  end
end


## our own code
$LOAD_PATH.unshift( '../rubidity-typed/lib' )
$LOAD_PATH.unshift( '../rubidity/lib' )
$LOAD_PATH.unshift( '../rubidity-contracts/lib' )
require 'rubidity'
require 'rubidity/contracts'

