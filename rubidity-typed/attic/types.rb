
class Type

alias_method :default_value, :zero   ## keep default_value alias - why? why not?


TYPES = [:string,  
             :address, :inscriptionId,
             :bytes32, :bytes,
             :bool, 
             :uint, :int, 
             :timestamp,
             :array, :mapping]
            
             
  ## legacy - use classes e.g is_a?( ArrayType ) - why? why not?
  TYPES.each do |type|  
     define_method( "#{type}?" ) do
         ## note: must be symbols both (symbol != string!!!)
         self.name == type
     end
  end


  def self.value_types
    ## note: use shared single (type) instances
    [:string,   
     :address, :inscriptionId,
     :bytes32,
     :bytes,   ### fix: see notes on bytes - is dynamic?? (reference value) double-check!!
     :bool,
     :uint, :int, 
     :timestamp, 
    ]
  end
 
end # class Type