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
