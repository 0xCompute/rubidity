
##
#  todo/fix:
#    always auto-add (default) constructor 
#      CAN get redefined
#       if not redefined
#         is empty BUT will call super construct (if has parent)!!!!


class ContractBase

  class << self
    attr_accessor :state_variable_definitions, 
                  :parent_contracts, 
                  :events, 
                  :is_abstract_contract
  end

  
##################
# parent contracts  
  def self.abstract
    @is_abstract_contract = true
  end
  

  def self.linearize_contracts( contract )
   ## for now 
    ##    include all classes before Contract
    ##    cache result - why? why not?

    ##
    ## todo/fix: check if include? Contract
    ##                    if not raise error - CANNOT linearize (no contract base found)
    classes = []
    contract.ancestors.each do |ancestor|
        break if ancestor == Contract ||
                 ancestor == ContractBase
        if ancestor.instance_of?( Class )
            classes << ancestor 
        else  ### assume Module
            puts "[debug] skipping module - #{ancestor.name} : #{ancestor.class.name}"
        end
    end    
    classes
  end

  def self.linearized_parents
    ## note: exclude self (that is, cut-off first class)
    linearize_contracts( self )[1..-1]
  end

  class << self
     ## note: for now the same (might change with support for module?)
     alias_method :parent_contracts, :linearized_parents 
  end


  
########
# state variables
  def self.state_variable_definitions
    @state_variable_definitions ||= {}
  end


  def self.define_state_variable(type, args)
    ## note: REMOVE last item from array (use Array#pop)
    ##  make sure name is ALWAYS a symbol!!!
    name = args.pop.to_sym
    
    if state_variable_definitions[name]
      raise "No shadowing: #{name} is already defined."
    end

    ## check for visibility  - internal/private/public
    ##  note: make :public default and :internal only if name starting with underscore (_) - why? why not?
    visibility = name.start_with?( '_' ) ? :internal  : :public    
 
 #  note: for now NO support for immutable and constant!!!!!   
 #   immutable  = false
 #   constant   = false

    ##  todo/check - force strict check for double (public/private etc.) use - why? why not?
    args.each do |arg|
      case arg
      when :public, :private, :internal then  visibility = arg
 #     when :immutable                   then  immutable = true
 #     when :constant                    then  constant = true
      else
         raise ArgumentError, "unknown type qualifier >#{arg}<; sorry for typedef #{type} in #{args.inspect}" 
      end
    end
    
    state_variable_definitions[name] = { type: type, 
                                         visibility: visibility }
                                       #  immutable: immutable,
                                       #  constant: constant 
    
  
    ## check - visibility 
    if visibility == :public
       contract_class = self
       Generator.getter_function( contract_class, name, type  )
    end
    
    type
  end


  def self.storage( **kwargs )
    ## note: assume keys are names and values are types for storage
    ## note:  allow multiple calls of storage!!!
    
    kwargs.each do |name, type|
       type = typeof( type )  
             
       ## add support for more args - e.g. visibility or such - why? why not?
       args = [name] 
       define_state_variable( type, args )                       
    end
  end 
 
  

####
#  functions / abis

def self.abi
    @abi ||= AbiProxy.new(self)
end

def self.public_abi() abi.public_api; end
def public_abi() self.class.public_abi; end


end  # classContractBase

