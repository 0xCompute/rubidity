require_relative 'helper'


class TestMapping < ContractImplementation    

  ## from ERC20
  storage  balanceOf: mapping( :address, :uint256 ),  
           allowance: mapping( :address, mapping( :address, :uint256))

  ## from ERC721         
  storage  _ownerOf:  mapping( :uint256, :address ),   
            _balanceOf: mapping( :address, :uint256 ),  
            getApproved: mapping( :uint256, :address ), 
            isApprovedForAll: mapping( :address, mapping( :address, :bool))
          
  ## from GenerativeERC721          
  storage  tokenIdToSeed: mapping( :uint256, :uint256 )  
  
  sig :constructor, []        
  def constructor
  end  
end  # class TestMapping  
  


pp TestMapping.state_variable_definitions
## pp TestMapping.parent_contracts 
pp TestMapping.events 
pp TestMapping.is_abstract_contract

abi = TestMapping.abi

pp TestMapping.public_abi
  

contract = TestMapping.create
pp contract


## test globals (context)
pp contract.msg
pp contract.msg.sender
contract.msg.sender = '0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'   # a(lice)
pp contract.msg.sender



initial_state = contract.serialize
pp initial_state  
#=> {"name"=>"", "symbol"=>"", "decimals"=>0, "totalSupply"=>0, "balanceOf"=>{}}
      

contract.constructor()

state = contract.serialize

pp contract.balanceOf( '0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa')

pp contract.serialize
#     "0xbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb"=>10000}}

pp contract.balanceOf( '0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa')
#=> 20990000 
pp contract.balanceOf( '0xbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb')
#=> 10000


allowance = contract.instance_variable_get( :@allowance )
pp allowance
allowance['0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa']['0xbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb']=100
allowance['0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa']['0xcccccccccccccccccccccccccccccccccccccccc']=200
pp allowance
pp contract.serialize


pp allowance[ '0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa']['0xbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb']
pp allowance[ '0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'][ '0xcccccccccccccccccccccccccccccccccccccccc']

pp contract.allowance( '0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa', '0xbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' )
pp contract.allowance( '0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa', '0xcccccccccccccccccccccccccccccccccccccccc' )


puts "bye"
