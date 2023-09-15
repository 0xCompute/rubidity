

class StateProxy

  attr_reader :state_variables


  def initialize( definitions )
     ## was {}.with_indifferent_access
     @state_variables = HashWithIndifferentAccess.new
    
     definitions.each do |name, definition|
        @state_variables[name] = StateVariable.create(name, 
                                                    definition[:type], 
                                                    definition[:args])
     end

     @state_variables.each do |name, var|
         puts "[debug] auto-add stateproxy getter #{var.name} : #{var.type}"
         define_singleton_method( name ) do
            ##var.typed_variable
            ivar = instance_variable_get( :@state_variables )[ name ]  
            puts "[debug] stateproxy - getter #{ivar.name} : #{ivar.type}"
            ivar.typed_variable
         end
         ## note: only add setters if NOT constart or immutable!!!!   
         if !(var.constant? || var.immutable?) 
           puts "[debug] auto-add stateproxy setter #{var.name} : #{var.type}"
           define_singleton_method( "#{name}=" ) do |new_value|
             ivar = instance_variable_get( :@state_variables )[ name ]
             puts "[debug] stateproxy - setter #{ivar.name} : #{ivar.type}"
             ivar.typed_variable.replace( new_value )   
           end
         end           
      end       
  end

=begin
  def method_missing(name, *args)
    is_setter = name[-1] == '='
    var_name = is_setter ? name[0...-1].to_s : name.to_s
    
    var = state_variables[var_name]
    
    return super if var.nil?
    
    return var.typed_variable unless is_setter
      
    
    ## try calling setter (via Typed#replace)
    raise "constant state variable #{var.name}; cannot replace"  if var.constant?
    raise "immutable state variable #{var.name}; cannot replace" if var.immutable? 
      
    var.typed_variable.replace( args.first )
  end
=end  
  
  def serialize
    state_variables.each.with_object({}) do |(key, var), h|
      h[key] = var.typed_variable.serialize
    end
  end
  
  def deserialize(state_data)
    state_data.each do |var_name, value|
      state_variables[var_name.to_sym].typed_variable.deserialize( value )
    end
  end
  alias_method :load, :deserialize
end
