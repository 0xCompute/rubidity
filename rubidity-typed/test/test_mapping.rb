###
#  to run use
#     ruby -I ./lib -I ./test test/test_mapping.rb


require 'helper'


## note: require voter to avoid DUPLICATE definition (with undefined state/errors etc.)
require_relative 'voter'



class TestMapping < MiniTest::Test

  include Types


  Mapping_X_Int     = Mapping.build_class( String, Int )
  Mapping_X_Bool    = Mapping.build_class( String, Bool )
  Mapping_X_Voter   = Mapping.build_class( String, Voter )

  ## nested e.g. String => (String => Int)
  Mapping_Mapping_X_Int = Mapping.build_class( String, Mapping_X_Int )

  Struct.build_class( :Game123, scope: Types, 
                                host:       String,
                                challenger: String,
                                turn:       String)
  pp Game123
  pp Game123.new


def test_mapping_of_mapping
  ## note: use Game123 (with unique/unused name)
  ##   for testing an "anonymous" hash class (e.g. without a class name)
   h = Mapping.build_class( String, Mapping.build_class( String, Game123 ))
   pp h
   h2 = Mapping.build_class( String, Mapping.build_class( String, Game123 ))
   pp h2
   assert true
end


def test_integer
  pp Mapping_X_Int
  pp h = Mapping_X_Int.new

  assert_equal false, h.key?( '0x1111' )
  assert_equal false, h.has_key?( '0x1111' )

  ## todo/fix: remove size and length for (safe) hash - why? why not?
  assert_equal 0, h.instance_variable_get('@data').size
  assert_equal 0, h.instance_variable_get('@data').length

  assert_equal true, Mapping_X_Int.zero == h
  assert_equal true, Mapping_X_Int.zero == Mapping_X_Int.new
  assert_equal true, Mapping_X_Int.zero == Mapping_X_Int.type.new_zero

  assert_equal true, h.zero?
  assert_equal true, Mapping_X_Int.zero.zero?
  assert_equal true, Mapping_X_Int.new.zero?
  assert_equal true, Mapping_X_Int.type.new_zero.zero?

  pp Mapping_X_Int.zero

  # assert_equal true,   Mapping_X_Int.zero.frozen?
  assert_equal false,  Mapping_X_Int.new.frozen?
  assert_equal false,  h.frozen?

  pp Mapping_X_Int.type
  assert_equal Int.type, Mapping_X_Int.type.value_type

  pp h['0x1111']   #=> <val int:0>
  pp h['0x2222']   #=> <val int:0>

  assert_equal 0,  h['0x1111'] 
  assert_equal 0,  h['0x2222']


  h['0x1111'] = 101
  h['0x2222'] = 102
  assert_equal 101,  h['0x1111']
  assert_equal 102,  h['0x2222']

  ## check Mapping.build_class  (uses cached classes)
  assert_equal Mapping_X_Int, Mapping.build_class( String, Int )
end


def test_bool
  pp Mapping_X_Bool
  pp h = Mapping_X_Bool.new

  assert_equal Bool.type, Mapping_X_Bool.type.value_type
  assert_equal true,  h['0x1111'] == false
  assert_equal true,  h['0x2222'] == false

  h['0x1111'] = true
  h['0x2222'] = true
  assert_equal true,  h['0x1111'] == true
  assert_equal true,  h['0x2222'] == true

  ## check Mapping.build_class  (uses cached classes)
  assert_equal Mapping_X_Bool, Mapping.build_class( String, Bool )
end


def test_voter
  pp Mapping_X_Voter
  pp h = Mapping_X_Voter.new

  assert_equal Voter.type, Mapping_X_Voter.type.value_type
  assert_equal true, Voter.zero == h['0x1111']
  assert_equal true, Voter.zero == h['0x2222']

  h['0x1111'].voted = true
  h['0x2222'].voted = true

  puts "==> voted?"
  pp h['0x1111']
  pp h['0x2222']

  assert_equal true,  h['0x1111'].voted == true   
  assert_equal true,  h['0x2222'].voted == true   
  assert_equal true,  h['0x1111'].voted? == true
  assert_equal true,  h['0x2222'].voted? == true

 
  ## check Hash.of  (uses cached classes)
  assert_equal Mapping_X_Voter, Mapping.build_class( String, Voter )
end

def test_allowances   # nested mappings
   ## allowances = Hash.of( String => Hash.of( String => Integer ) )
   allowances = Mapping_Mapping_X_Int.new

   allowances['0x1111']['0xaaaa'] = 100
   allowances['0x1111']['0xbbbb'] = 200
   allowances['0x2222']['0xaaaa'] = 300
   pp allowances

   assert_equal 100, allowances['0x1111']['0xaaaa']
   assert_equal 200, allowances['0x1111']['0xbbbb']
   assert_equal 300, allowances['0x2222']['0xaaaa']

   puts "==> allowances"
   allowances['0x2222'].delete( '0xaaaa' )
   pp allowances
  
   assert_equal 0, allowances['0x2222']['0xaaaa']


   ##############################################
   ## try Mapping convenience helper
   allowances = Mapping.build_class( String, Mapping.build_class( String, Int )).new

   allowances['0x1111']['0xaaaa'] = 100
   allowances['0x1111']['0xbbbb'] = 200
   allowances['0x2222']['0xaaaa'] = 300
   pp allowances

   assert_equal 100, allowances['0x1111']['0xaaaa']
   assert_equal 200, allowances['0x1111']['0xbbbb']
   assert_equal 300, allowances['0x2222']['0xaaaa']

   allowances['0x2222'].delete( '0xaaaa' )
   assert_equal 0, allowances['0x2222']['0xaaaa']
end


def test_mapping_new
    ## note: Mapping.new|build_class (returns a class!! not an object (instance)!!!
    h = Mapping.build_class( String, Int )   
 
    assert_equal true,  h.is_a?( Class )
    assert_equal false, h.new.is_a?( Class )
end

end # class TestMapping
