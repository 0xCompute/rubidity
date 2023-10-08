

class AbiProxy
  
  ## todo: make data private!!!
  ##  make  read access available via #each !!!
  attr_accessor :contract_class
  
  def initialize(contract_class)
    @contract_class = contract_class
    @generated = false

    parents = contract_class.linearized_parents 
    if parents.empty?
      ## do nothing
    else 
      _merge_state_variables( parents)
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
     ## generate global function (e.g. ERC20() or such)
     Generator.global_function( contract_class )

     # sigs.each do |name, definition|
     #    Generator.typed_function( contract_class, name, 
     #                                  inputs: definition[:inputs] )
     #  end
     _contract_classes << contract_class
   end
end


  ### todo/check -- where used? check for parent_contracts
  # def parent_contracts
  #  contract_class.parent_contracts
  # end
  
  
  
  def _merge_state_variables( parents )
    puts "[debug] AbiProxy#merge_parent_state_variables - #{contract_class}"
    parent_state_variables = parents.map(&:state_variable_definitions).reverse
    vars = parent_state_variables.reduce( {} ) { |mem,h| mem.merge(h) }
                                 .merge( contract_class.state_variable_definitions)
    puts "[debug]   merged state_variables:"
    pp vars
    contract_class.state_variable_definitions = vars    
  end 
    
 

  def public_abi
    ### note: calculate for now on-the-fly - why? why not?
    ##   cache results - why? why not?
    contracts = [@contract_class] + @contract_class.linearized_parents
    ## note: use reverse order - 
    ##         most concreate comes last (for override)
    contracts = contracts.reverse  


    ## todo/fix: add (contract) klass for source to data???  - why? why not?
    data = {}

    contracts.each do |klass|
      klass.sigs.each do |name, definition|
           if definition[:options].include?( :public )
              ## check for override 
              ##   and issue info for now 
                if data.has_key?( name )
                  ## Solidity lets developers change how a function in the parent contract is implemented
                  ##  in the derived class. This is known as function overriding. 
                  ##  The function in the parent contract needs to be declared with
                  ##  the keyword virtual to indicate that it can be overridden 
                  ## in the deriving contract.
                  ##  
                  ##   todo: check for virtual keyword - why? why not?
                    if name == :constructor
                      puts "   overriding constructor in #{klass.name}"
                    else
                      puts "   overriding function #{name} in #{klass.name}"
                    end
                end
                data[name] = definition  
           else
              puts "   skip non-public sig - #{name} #{definition.inspect}"
           end
      end
    end

    data
  end
  alias_method :public_api, :public_abi   ## only use public_abi (not api) - why? why not?


  ## rename to to_abi_json or export_abi_json or solidity_abi_json or ??
  def public_abi_as_json
   ##
   ## todo/fix: add events too!!!
   ## todo/fix:  add input parameter names too!!!!

# json format:    
#      Type - defines the nature of the function (receive, fallback, constructor) 
#      Name - defines the name of the function
#      Inputs - array of objects with name, type, components
#      Outputs - array of objects similar to inputs
#      stateMutability - defines the mutability of the function (pure, view, non-payable or payable) 
#
#  "type": "constructor",
#  "inputs": [
#   { "type": "string", "name": "symbol" },
#   { "type": "string", "name": "name" }
#  ]
#
#  "type": "function",
#  "name": "balanceOf",
#  "stateMutability": "view",
#    "inputs": [
#      { "type": "address", "name": "owner"}
#    ],
#    "outputs": [
#      { "type": "uint256"}
#    ]

     data = []
 
     public_abi.each do |name, definition|
                   inputs = definition[:inputs].map do |input|
                                             ## todo: use a _arg1, _arg2, 
                                             ##   count or such - why?
                                          { 'type' => input.to_s,
                                            'name' => '_'
                                          }
                                     end  

                    state_mutability = 'nonpayable'  ## default is nonpayable (double check)
                    state_mutability = 'view'   if definition[:options].include?( :view )

               if name == :constructor
                   data << { 
                              'type'            => 'constructor', 
                              'stateMutability' => state_mutability,
                              'inputs'          =>  inputs
                            }     
               else
                   ## check if outputs is a single entry or array or nil or hash?
                   outputs = definition[:outputs].is_a?( Array ) ?
                                      definition[:outputs]  : [definition[:outputs]] 
                   outputs = outputs.map do |output|
                                             ## todo: use a _arg1, _arg2, 
                                             ##   count or such - why?
                                          { 'type' => output.to_s,
                                            'name' => '_'
                                          }
                                     end  

                   data << {
                              'type'     => 'function', 
                              'name'     =>  name.to_s,                    
                              'stateMutability' => state_mutability,
                              'inputs'   =>  inputs,
                              'outputs'  =>  outputs,
                           }
               end              
     end
     data   
  end


  def public_abi_to_json
      JSON.pretty_generate( public_abi_as_json )
  end
end  # class  AbiProxy
