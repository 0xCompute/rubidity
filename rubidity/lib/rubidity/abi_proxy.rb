

class AbiProxy
  
  ## todo: make data private!!!
  ##  make  read access available via #each !!!
  attr_accessor :contract_class
  
  def initialize(contract_class)
    @contract_class = contract_class
    @data = {}    
    @generated = false

    parents = contract_class.linearized_parents 
    if parents.empty?
      ## do nothing
    else 
      _merge_events( parents )  
      _merge_state_variables( parents)
      _merge_abis( parents )  
    end
  end

###
##  keep a list of generated classes (only needed/possible to generatae once)
def self.contract_classes() @classes ||= []; end
def _contract_classes() self.class.contract_classes; end


## generated? - use flag to keep track of code generation (only one time needed/required)  
def generated?() @generated; end
def generate_functions
  @generated = true
  puts "==> generate (typed) functions for #{@contract_class.name}"
  
  parents = @contract_class.linearized_parents 
  ## revesee order - why? why not?
  parents.each do |parent|
    _generate_functions( parent )
  end
  _generate_functions( @contract_class )
end


def _generate_functions( contract_class )
  ## start with simple (no parents) for now

   sigs = contract_class.sigs
   puts "#{sigs.size} function signatures in #{contract_class.name}:"
   pp sigs

   ## note: only generate once for now!!!!
   ##        maybe check later if new sigs?? possible? why? why not?
   if _contract_classes.include?( contract_class )
       puts "   already generated!"
   else
     sigs.each do |name, definition|
        Generator.typed_function( contract_class, name, 
                                      inputs: definition[:inputs] )
     end
     _contract_classes << contract_class
   end
end


  ### todo/check -- where used? check for parent_contracts
  # def parent_contracts
  #  contract_class.parent_contracts
  # end
  
  
  def _merge_events( parents )
    parent_events = parents.map(&:events).reverse
    contract_class.events = parent_events.reduce( {} ) { |mem,h| mem.merge(h) }
                                         .merge(contract_class.events)
  end
  
  def _merge_state_variables( parents )
    puts "[debug] AbiProxy#merge_parent_state_variables - #{contract_class}"
    parent_state_variables = parents.map(&:state_variable_definitions).reverse
    vars = parent_state_variables.reduce( {} ) { |mem,h| mem.merge(h) }
                                 .merge( contract_class.state_variable_definitions)
    puts "[debug]   merged state_variables:"
    pp vars
    contract_class.state_variable_definitions = vars    
  end
 
    
  def _merge_abis( parents ) ; end
 
  def public_api
    @data.select do |name, details|
                        ## details.publicly_callable?
                        true
                  end
  end
end  # class  AbiProxy
