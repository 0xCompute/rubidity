

class ContractBase

  class << self
    attr_accessor :state_variable_definitions, 
                  :parent_contracts, 
                  :events, 
                  :is_abstract_contract
  end

  def self.pragma(*args)
    # Do nothing for now
  end
  
##################
# parent contracts  
  def self.abstract
    @is_abstract_contract = true
  end
  
  def self.parent_contracts
    @parent_contracts ||= []
  end
  
  def self.is(*constants)
    self.parent_contracts += constants.map{|i| "Contracts::#{i}".safe_constantize}
    self.parent_contracts = self.parent_contracts.uniq
  end
  
  def self.linearize_contracts(contract, processed = [])
    return [] if processed.include?(contract)
  
    new_processed = processed + [contract]
  
    return [contract] if contract.parent_contracts.empty?
    linearized = [contract] + contract.parent_contracts.reverse.flat_map { |parent| linearize_contracts(parent, new_processed) }
    linearized.uniq { |c| raise "Invalid linearization" if linearized.rindex(c) != linearized.index(c); c }
  end
  
  def self.linearized_parents
    linearize_contracts(self)[1..-1]
  end
 


 ####
 # events
 def self.event(name, args)
    @events ||= HashWithIndifferentAccess.new
    @events[name] = args
  end

  def self.events
    @events || HashWithIndifferentAccess.new
  end
 

########
# state variables
  def self.state_variable_definitions
    @state_variable_definitions ||= {}
  end


  def self.define_state_variable(type, args)
    name = args.last.to_sym
    type = Type.create(type)
    
    if state_variable_definitions[name]
      raise "No shadowing: #{name} is already defined."
    end
    
    state_variable_definitions[name] = { type: type, 
                                         args: args }
    
    ## todo/check: why create state var here - not used?
    ##   will get created with stateproxy later from defs - double check!!!!
    ## state_var = StateVariable.create(name, type, args)
    ## state_var = StateVariable.new(name, type, args)
  
    ## check - visibility 
    if args.include?( :public )   # was: @visibility == :public
       create_public_getter_function( name, type, constant: args.include?( :constant ),
                                                  immutable: args.include?( :immutable ))
    end
    
    type
  end


  Type.value_types.each do |type|
    define_singleton_method(type) do |*args|
      define_state_variable(type, args)
    end
  end
  
  def self.mapping(*args)
    key_type, value_type = args.first.first
    type = Type.create( :mapping, key_type: key_type, 
                                  value_type: value_type )
    
    if args.last.is_a?(Symbol)
      define_state_variable(type, args)
    else
      type
    end
  end
  
  def self.array(*args)
    sub_type = args.first
    type = Type.create(:array, sub_type: sub_type )
    
    define_state_variable(type, args)
  end


####
#  functions / abis

def self.abi
    @abi ||= AbiProxy.new(self)
end

def self.public_abi
    abi.select do |name, details|
      details.publicly_callable?
    end
end
def public_abi() self.class.public_abi; end
  


def self.function( name, args, *options, returns: nil, &block)
    abi.create_and_add_function(name, args, *options, returns: returns, &block)
end
  
def self.constructor(args = {}, *options, &block)
    function(:constructor, args, *options, returns: nil, &block)
end
  




###
#  add public getters helpers
  def self.create_public_getter_function(  name, type, constant: false,
                                                       immutable: false )
    
    if type.mapping?
      create_mapping_getter_function( name, type, constant: constant,
                                                  immutable: immutable )
    elsif type.array?
        puts "[debug] auto-generate public array getter - #{name} : #{type}:"
        function( name, {index: :uint256},
                       :public, :view, returns: type.sub_type.name) do
          puts "[debug] call public (state) array getter for #{name} : #{type} with index #{send(:index)}"
          value = s.send( name)
          value[send(:index)]
      end
    else
      puts "[debug] auto-generate public getter - #{name} : #{type}:"
      function( name, {}, 
                       :public, :view, returns: type.name) do
          puts "[debug] call public (state) getter for #{name} : #{type}"
          s.send(name)
       end
    end
  end
  

  def self.create_mapping_getter_function( name, type, constant: false,
                                                       immutable: false)
    arguments = {}
    index = 0
    current_type = type

    while current_type.name == :mapping
      arguments["arg#{index}".to_sym] = current_type.key_type.name
      current_type = current_type.value_type
      index += 1
    end
    
    puts "[debug] auto-generate public mapping getter - #{name} : #{type}:"
    puts "    arguments:"
    pp   arguments
    puts "    index: #{index}"
# {:arg0=>:addressOrDumbContract}
#    index: 1

    function( name, arguments, :public, :view, returns: current_type.name) do
        puts "[debug] call public (state) mapping getter for #{name} : #{type}"
        value = s.send(name)
        (0...index).each do |i|
          value = value[send("arg#{i}".to_sym)]
        end
        value
    end
  end
end  # classContractBase

