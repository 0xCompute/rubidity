
class ERC20Receiver < ERC20
  sig :constructor, []
  def constructor
    super( name: "bye", symbol: "B", decimals: 18 )
  end
end


class ERC20Minimal < ERC20
  sig :constructor, [:string, :string, :uint256] 
  def constructor(name:, symbol:, decimals: ) 
    super( name: name, symbol: symbol, decimals: decimals )
  end
end


class AddressArg < ContractImplementation
  event :SayHi,    { sender: :address }
  event :Responded, { response: :string }
  
  sig :constructor, [:address]
  def constructor(testAddress:) 
    log :SayHi, sender: testAddress
  end
  
  sig :respond, [:string]
  def respond( greeting: )
    log :Responded, response: (greeting + " back")
  end
end


class Receiver < ContractImplementation
  event :MsgSender, { sender: :address }
  
  sig :constructor, []
  def constructor
  end

  sig :sayHi, [], :view, returns: :string
  def sayHi
    "hi"
  end
  
  sig :receiveCall, [], returns: :uint256
  def receiveCall
    log :MsgSender, sender: msg.sender
    
    ## block.number
    888   ## fix: change back to block.number!!!
  end
  

  sig :_internalCall, []
  def _internalCall
  end
  
  sig :name, [], :view, returns: :string
  def name
     "hi"
  end
end




class Caller < ContractImplementation
  event :BlockNumber, { number: :uint256 }
  
  sig :constructor, []
  def constructor
  end

  sig :makeCall, [:address],  returns: :string
  def makeCall( receiver: )
    resp = Receiver(receiver).receiveCall()
    
    log :BlockNumber, number: 888   ##block.number
    log :BlockNumber, number: resp
    
    Receiver(receiver).sayHi()
  end
  
  sig :callInternal, [:address]
  def callInternal( receiver: ) 
    Receiver(receiver)._internalCall()
  end
  
  sig :testImplements, [:address], returns: :string
  def testImplements( receiver: )
    ERC20(receiver).name()
  end
end



class Deployer < ContractImplementation
  event :ReceiverCreated, { contract: :address }
  event :ContractCreated, { contract: :address }

  sig :constructor, [] 
  def constructor
  end
  
  sig :createReceiver, [:string, :string, :uint256], returns: :address
  def createReceiver( name:,
                      symbol:,
                      decimals: )
    erc20 = ERC20Minimal.construct(name, symbol, decimals)
    
    log :ReceiverCreated, contract: erc20.address
    
    erc20.address
  end

  sig :createMalformedReceiver, [:string], returns: :address
  def createMalformedReceiver( name: )
    erc20 = ERC20Minimal.construct(name)

    log :ReceiverCreated, contract: erc20.address
    
    erc20.address
  end
  
  sig :createAddressArgContract, [:address], returns: :address
  def createAddressArgContract( testAddress: )
    contract = AddressArg.construct( testAddress )

    log :ReceiverCreated, contract: contract.address

    contract.address
  end
  
  sig :createAddressArgContractAndRespond, [:address, :string]
  def createAddressArgContractAndRespond( testAddress:, greeting: )
    contract = AddressArg.construct( testAddress )
    log :ReceiverCreated, contract: contract.address
    contract.respond(greeting)
  end
  
  sig :createERC20Minimal, [:string, :string, :uint256], returns: :address
  def createERC20Minimal( name:, symbol:, decimals: )
    contract = ERC20Minimal.construct(name, symbol, decimals)
    
    log :ContractCreated, contract: contract.address
    
    contract.address
  end
  
  sig :callRespond, [:address, :string]
  def callRespond( contract_address:, greeting: )
    contract = AddressArg.construct(contract_address)
    contract.respond(greeting)
  end
end


class MultiDeployer < ContractImplementation 
  sig :constructor, [] 
  def constructor
  end

  sig :deployContracts, [:address], returns: :address
  def deployContracts( deployerAddress: )
    contract = CallerTwo.construct(deployerAddress)
    
    testNoArgs = MultiDeployer.construct()
    
    contract.callDeployer()
  end
end


class CallerTwo < ContractImplementation
  storage deployerAddress: :address 
  
  sig :constructor, [:address]
  def constructor( deployerAddress: ) 
    @deployerAddress = deployerAddress
  end
  
  sig :callDeployer, [], returns: :address
  def callDeployer
    deployer = Deployer( @deployerAddress )

    deployer.createERC20Minimal( "myToken", "MTK", 18 )
  end
end




