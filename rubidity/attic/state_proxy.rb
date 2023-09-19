


class StateProxy

  attr_reader :state_variables


  def initialize( definitions )
     puts "[debug] StateProxy#initialize"
     @state_variables = {}
    
     definitions.each do |name, definition|
         type      = definition[:type]
         constant  = definition[:constant] 
         immutable = definition[:immutable]
        
         ### note. create  TypedVariable instance here (via Type#create)
         @state_variables[name] = type.create 
   
         puts "[debug] auto-add stateproxy getter #{name} : #{type}"
         define_singleton_method( name ) do
            var = instance_variable_get( :@state_variables )[ name ]  
            puts "[debug] StateProxy#getter #{name} : #{var.type}"
            var
         end
         ## note: only add setters if NOT constart or immutable!!!!   
         if !(constant || immutable) 
           puts "[debug] auto-add stateproxy setter #{name} : #{type}"
           define_singleton_method( "#{name}=" ) do |new_value|
             var = instance_variable_get( :@state_variables )[ name ]
             puts "[debug] StateProxy#setter #{name} : #{var.type}"
             puts "#{new_value.pretty_print_inspect}"
             if new_value.is_a?( Typed )
                puts "   type match?  #{var.type==new_value.type}"
             end
             var.replace( new_value )   
           end
         end           
      end       
  end
  
  def serialize
    @state_variables.reduce({}) do |h, (name, var)|
      h[name] = var.serialize
      h
    end
  end
  alias_method :dump, :serialize  ### use dump as alias - why? why not?
 
  def deserialize(state_data)
    state_data.each do |name, value|
      ##  note: make sure name is ALWAYS a symbol!!!
      @state_variables[name.to_sym].deserialize( value )
    end
  end
  alias_method :load, :deserialize
end
