require_relative 'helper'


require_relative 'contract_implementation'

class TestContractImplemenation < MiniTest::Test


test "sets msg.sender correctly when one contract calls another" do 
=begin
    caller_deploy_receipt = trigger_contract_interaction_and_expect_success(
      command: 'deploy',
      from: "0xC2172a6315c1D7f6855768F843c420EbB36eDa97",
      data: {
        "protocol": "Caller",
        "constructorArgs": {},
      }
    )
=end

pp caller = Caller.construct

=begin
    receiver_deploy_receipt = trigger_contract_interaction_and_expect_success(
      command: 'deploy',
      from: "0xC2172a6315c1D7f6855768F843c420EbB36eDa97",
      data: {
        "protocol": "Receiver",
        "constructorArgs": {},
      }
    )
=end

pp receiver = Receiver.construct


=begin
    call_receipt = trigger_contract_interaction_and_expect_success(
      command: 'call',
      from: "0xC2172a6315c1D7f6855768F843c420EbB36eDa97",
      data: {
        "contract": caller_deploy_receipt.address,
        "functionName": "makeCall",
        "args": {
          "receiver": receiver_deploy_receipt.address,
        },
      }
    )
=end

pp last_call = caller.makeCall( receiver: receiver.address )

=begin
    last_call = call_receipt.contract_transaction.contract_calls.last
    
    expect(last_call.function).to eq("sayHi")
    expect(last_call.return_value).to eq("hi")
    expect(last_call.from_address).to eq(caller_deploy_receipt.address)
    expect(last_call.to_contract_address).to eq(receiver_deploy_receipt.address)
    
    block_number_logs = call_receipt.logs.select { |log| log['event'] == 'BlockNumber' }
    expect(block_number_logs.size).to eq(2)
    expect(block_number_logs[0]['data']['number']).to eq(block_number_logs[1]['data']['number'])

    expect(call_receipt.logs).to include(
      hash_including('event' => 'MsgSender', 'data' => { 'sender' => caller_deploy_receipt.address })
    )
=end

 assert_equal 'hi',  last_call


=begin
    trigger_contract_interaction_and_expect_call_error(
      command: 'call',
      from: "0xC2172a6315c1D7f6855768F843c420EbB36eDa97",
      data: {
        "contract": caller_deploy_receipt.address,
        "functionName": "callInternal",
        "args": {
          "receiver": receiver_deploy_receipt.address,
        },
      }
    )
=end  

  ## todo/fix:  make _callInternal  private!!!
  pp caller.callInternal( receiver: receiver.address )
end


test "raises an error when trying to cast a non-ERC20 contract as ERC20" do
=begin
    caller_deploy_receipt = trigger_contract_interaction_and_expect_success(
      command: 'deploy',
      from: "0xC2172a6315c1D7f6855768F843c420EbB36eDa97",
      data: {
        "protocol": "Caller",
        "constructorArgs": {},
      }
    )
=end 

   pp caller = Caller.construct

=begin 
   erc20_receiver_deploy_receipt = trigger_contract_interaction_and_expect_success(
      command: 'deploy',
      from: "0xC2172a6315c1D7f6855768F843c420EbB36eDa97",
      data: {
        "protocol": "ERC20Receiver",
        "constructorArgs": {},
      }
    )
=end 

   pp erc20_receiver = ERC20Receiver.construct
  
=begin   
    receiver_deploy_receipt = trigger_contract_interaction_and_expect_success(
      command: 'deploy',
      from: "0xC2172a6315c1D7f6855768F843c420EbB36eDa97",
      data: {
        "protocol": "Receiver",
        "constructorArgs": {},
      }
    )
=end 

   pp receiver = Receiver.construct

=begin
    trigger_contract_interaction_and_expect_success(
      command: 'call',
      from: "0xC2172a6315c1D7f6855768F843c420EbB36eDa97",
      data: {
        "contract": caller_deploy_receipt.address,
        "functionName": "testImplements",
        "args": {
          "receiver": erc20_receiver_deploy_receipt.address,
        },
      }
    )
=end

  pp caller.testImplements( receiver: erc20_receiver.address )


=begin
    trigger_contract_interaction_and_expect_call_error(
      command: 'call',
      from: "0xC2172a6315c1D7f6855768F843c420EbB36eDa97",
      data: {
        "contract": caller_deploy_receipt.address,
        "functionName": "testImplements",
        "args": {
          "receiver": receiver_deploy_receipt.address,
        },
      }
    )
=end

   assert_raises(TypeError) { 
       pp caller.testImplements( receiver: receiver.address ) 
   }
end


test 'creates contract from another contract' do
=begin
    deployer_deploy_receipt = trigger_contract_interaction_and_expect_success(
      command: 'deploy',
      from: "0xC2172a6315c1D7f6855768F843c420EbB36eDa97",
      data: {
        "protocol": "Deployer",
        "constructorArgs": {},
      }
    )
=end

   pp deployer =  Deployer.construct
   

=begin
    receiver_deploy_receipt = trigger_contract_interaction_and_expect_success(
      command: 'call',
      from: "0xC2172a6315c1D7f6855768F843c420EbB36eDa97",
      data: {
        "contract": deployer_deploy_receipt.address,
        "functionName": "createReceiver",
        "args": ["name", 'symbol', 10],
      }
    )
=end 

   pp receiver_addr = deployer.createReceiver( 'name', 'symbol', 10 )

=begin
    expect(receiver_deploy_receipt.logs).to include(
      hash_including('event' => 'ReceiverCreated')
    )
=end
end


test 'fails to create a contract with invalid constructor arguments' do 
=begin
    deployer_deploy_receipt = trigger_contract_interaction_and_expect_success(
      command: 'deploy',
      from: "0xC2172a6315c1D7f6855768F843c420EbB36eDa97",
      data: {
        "protocol": "Deployer",
        "constructorArgs": {},
      }
    )
=end

  pp deployer = Deployer.construct

=begin
    trigger_contract_interaction_and_expect_call_error(
      command: 'call',
      from: "0xC2172a6315c1D7f6855768F843c420EbB36eDa97",
      data: {
        "contract": deployer_deploy_receipt.address,
        "functionName": "createMalformedReceiver",
        "args": {},
      }
    )
=end
   assert_raises(ArgumentError) { 
       pp deployer.createMalformedReceiver
   }
end


test 'creates contract with address argument without ambiguity' do 
=begin
    # First, we deploy an arbitrary contract to get an address
    dummy_deploy_receipt = trigger_contract_interaction_and_expect_success(
      command: 'deploy',
      from: "0xC2172a6315c1D7f6855768F843c420EbB36eDa97",
      data: {
        "protocol": "ERC20Minimal",
        "constructorArgs": ["name", 'symbol', 10],
      }
    )
=end

  dummy_deploy = ERC20Minimal.construct( 'name', 'symbol', 10 )

=begin
    # Now we deploy the Deployer contract
    deployer_deploy_receipt = trigger_contract_interaction_and_expect_success(
      command: 'deploy',
      from: "0xC2172a6315c1D7f6855768F843c420EbB36eDa97",
      data: {
        "protocol": "Deployer",
        "constructorArgs": {},
      }
    )
=end

   deployer = Deployer.construct

=begin
    # Deploy a contract where its only argument (`testAddress`) could be 
    # ambiguously interpreted as constructor parameter or a contract address
    receiver_deploy_receipt = trigger_contract_interaction_and_expect_success(
      command: 'call',
      from: "0xC2172a6315c1D7f6855768F843c420EbB36eDa97",
      data: {
        "contract": deployer_deploy_receipt.address,
        "functionName": "createAddressArgContract",
        "args": [dummy_deploy_receipt.address],
      }
    )
=end

    pp receiver_deploy = deployer.createAddressArgContract( dummy_deploy.address )


=begin
    # It should still pass and create the contract successfully
    expect(receiver_deploy_receipt.logs).to include(
      hash_including('event' => 'ReceiverCreated')
    )
  
    # It should capture the testAddress in the SayHi event log
    expect(receiver_deploy_receipt.logs).to include(
      hash_including('event' => 'SayHi', 'data' => { 'sender' => dummy_deploy_receipt.address })
    )

    response = trigger_contract_interaction_and_expect_success(
      command: 'call',
      from: "0xC2172a6315c1D7f6855768F843c420EbB36eDa97",
      data: {
        "contract": deployer_deploy_receipt.address,
        "functionName": "createAddressArgContractAndRespond",
        "args": [dummy_deploy_receipt.address, "Hello"],
      }
    )
=end

  pp response = deployer.createAddressArgContractAndRespond( 
                        dummy_deploy.address, 
                        'Hello' )

=begin
    expect(response.logs).to include(
      hash_including('event' => 'ReceiverCreated')
    )
  
    expect(response.logs).to include(
      hash_including('event' => 'Responded', 'data' => {'response' => 'Hello back'})
    )
=end
end


test 'creates and invokes contracts in complex nested operations' do
=begin
    # first, we need a Deployer that can be used by Candidate to create new tokens
    deployer_deploy_receipt = trigger_contract_interaction_and_expect_success(
      command: 'deploy',
      from: "0xC2172a6315c1D7f6855768F843c420EbB36eDa97",
      data: {
        "protocol": "Deployer",
        "constructorArgs": {},
      }
    )
=end

   pp deployer = Deployer.construct

=begin
    # then deploy the MultiDeployer
    multi_deployer_deploy_receipt = trigger_contract_interaction_and_expect_success(
      command: 'deploy',
      from: "0xC2172a6315c1D7f6855768F843c420EbB36eDa97",
      data: {
        "protocol": "MultiDeployer",
      }
    )
=end

   pp multi_deployer = MultiDeployer.construct

=begin
    # call the MultiDeployer's deployContracts function, which should deploy the Caller contract
    deploy_contracts_receipt = trigger_contract_interaction_and_expect_success(
      command: 'call',
      from: "0xC2172a6315c1D7f6855768F843c420EbB36eDa97",
      data: {
        "contract": multi_deployer_deploy_receipt.address,
        "functionName": "deployContracts",
        "args": deployer_deploy_receipt.address,
      }
    )
=end
   pp deploy_contracts = multi_deployer.deployContracts( deployer.address ) 

=begin    
    # there should be a ContractCreated event which indicates that a new contract was created
    expect(deploy_contracts_receipt.logs).to include(
      hash_including('event' => 'ContractCreated')
    )
    
    # take the contract address from the event log
    created_erc20_address = deploy_contracts_receipt.logs.find { |l| l['event'] == 'ContractCreated' }['data']['contract']
    # binding.pry
    # verify that the created contract really is a ERC20Minimal
    # created_erc20_contract = ERC20Minimal(created_erc20_address)
    # expect(created_erc20_contract.name).to eq('myToken')
=end
end
end #  class TestContractImplemenation < MiniTest::Test

