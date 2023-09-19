
def initialize(contract_record)
      @state_proxy = StateProxy.new(
        ## was: 
        ##  contract_record.type.constantize.state_variable_definitions
         self.class.state_variable_definitions 
      )
end  


  def self.parent_contracts
    @parent_contracts ||= []
  end

  def self.is(*constants)
    self.parent_contracts += constants   #  note: was .map{ |i| i.safe_constantize }
    ## todo/fix: report error on duplicates or silently remove (vai uniq) - why? why not?
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


  ###
  #  add convenience serialize/deserialize(load) helpers - why? why not?
  def serialize() @state_proxy.serialize; end
  alias_method :dump, :serialize  ### use dump as alias - why? why not?
  def deserialize(state_data)  @state_proxy.deserialize( state_data ); end
  alias_method :load, :deserialize
  
  def s
    @state_proxy
  end
  alias_method :state_proxy, :s    ## keep state_proxy alias - why? why not?
  

