

##
#  "centralize"
##   meta-programming magic (code generation) in module here - why? why not?
##    find a better name e.g Magic? Pilot? or CodeGen or Metagen or ???
module Generator


############
## helpers
def self._demodulize( path )
   ## turn class.name into a symbol cutting off all namepspaces (::)
   ##  e.g.  Contracts::ERC20 => ERC20 
   ##
   ##  note: ActiveSupport::String#demodulize is the same (for string)

   path = path.to_s 
   if i = path.rindex('::')
     path[(i+2)..-1]
   else
     path
   end
end   



module Function
####
##  rename to pack_params/args or cook_params or typed_params or ???
def self.params( method, inputs, *args_unsafe, **kwargs_unsafe )
    m = method
    params = m.parameters
    ## puts "params for #{m} - #{m.owner}:"
    ## pp params
    
    ## e.g.
    ## [[:keyreq, :name], 
    ##  [:keyreq, :symbol], 
    ##  [:keyreq, :decimals], 
    ##  [:keyreq, :totalSupply]]
    ## get keys
    keys = params.map { |param| param[1] }
    ## puts "keys:"
    ## pp keys
 
    kwargs =  if !args_unsafe.empty? 
                 values = inputs.zip( args_unsafe ).map do |type, value|
                            ## todo/check:  change create to cast/try_cast or such - why? why not?
                            ##                might already be proper type? no?
                            TypedVariable.create(type, value)
                          end
                 ## puts "args:"
                 ## puts values.pretty_print_inspect

                 keys.zip( values ).map do |key,value|
                                         [key,value]
                 end.to_h
              elsif !kwargs_unsafe.empty?
                 types = keys.zip( inputs ).map do |key,type|
                                         [key,type]
                         end.to_h
                 ## puts "types:"
                 ## pp types
                 kwargs_unsafe.map do |key,value|
                    type = types[key]
                    raise ArgumentError, "unknown kwarg #{key}; sorry"   if type.nil?
                    [key, TypedVariable.create( type, value)]
                end.to_h
              else
                ## assume no args - e.g. construct - double check for empty input spec/def!!!
                if inputs.empty?
                  {}   
                else
                  raise ArgumentError, "Array (args) or Hash (kwargs) required for func call; sorry"
                end
              end

    puts "kwargs:"
    pp kwargs
end
end  # module Function


## to rename to generate_typed or generate_wrapped or ??
##      typed_method??
def self.typed_function( contract_class, name, inputs: )  
    ## note: must? find matching method in class
    ## todo/fix:  use methods( false) if available (do NOT look-up in subclasses or such)

    ## note: make sure name and contract_name is always a symbol
    name          = name.to_sym
    contract_name = _demodulize( contract_class.name ).to_sym   
 
            exists = contract_class.instance_methods( false ).include?( name )
            if !exists
              error_message = "[ERRRO] no method #{name} found for sig in class #{contract_class.name}"
              puts error_message
              ## fix: change to NoMethodError - exists?
              raise NameError, error_message
            end
      
            ## m = contract_class.method( name )
            ## puts "  bingo! #{name} - #{m.owner}"
            puts "  bingo! #{name}"
        
            ##
            ##  use :name_raw instead of :name_unsafe - why? why not?
 
            ## rewire
            ##   alias_method :name_unsafe, :name
            ##   alias_method :name,        :name_typed 
            contract_class.class_eval do

               define_method :"__#{contract_name}__#{name}" do |*args_unsafe,**kwargs_unsafe|
                  puts "==> calling __#{contract_name}__#{name} (#{contract_class.name})"
        
                  m = method( :"__#{contract_name}__#{name}_unsafe" )
                  kwargs = Function.params( m, inputs, *args_unsafe, **kwargs_unsafe )
                  
                  ret = m.call( **kwargs )
                  ## todo/fix:
                  ##   check returns type / value too
                  ret
               end 
      
               ## note: must add class/contract name (via prefix) here!! 
               ## rename (unsafe/untyped) method
               alias_method :"__#{contract_name}__#{name}_unsafe", name
               alias_method name,  :"__#{contract_name}__#{name}"
               if name == :constructor  ### add ERC20() or such
                  alias_method contract_name, :"__#{contract_name}__#{name}"
               end
            end
end  # method typed_function


###
#  add public getters helpers
def self.getter_function(  contract_class, name, type, 
                             constant: false,
                             immutable: false )  
    ## note: make sure name is always a symbol
    name          = name.to_sym

    if type.mapping?
        mapping_getter_function( contract_class, name, type, 
                                            constant: constant,
                                            immutable: immutable )
    elsif type.array?
      puts "[debug] auto-generate public array getter - #{name} : #{type}:"

    
      ## auto-add/register sig(nature) in here - why? why not?
      contract_class.sig( name, [:uint256], :view, returns: type.sub_type.name )

      contract_class.class_eval do
        ## note: hack: must use kwargs for now!!! index: (not index) for now
        define_method :"#{name}" do |index:|
          puts "[debug] call public (state) array getter for #{name} : #{type} with index #{index} (#{contract_class.name})"
          puts "[debug]  self -> #{self}"
          value = instance_variable_get( :"@#{name}" )
          value[index]   
        end
      end # class_evel
    else
      puts "[debug] auto-generate public getter - #{name} : #{type}:"

      ## auto-add/register sig(nature) in here - why? why not?
      contract_class.sig( name, [], :view, returns: type.name )

      contract_class.class_eval do
       define_method :"#{name}" do
         puts "[debug] call public (state) getter for #{name} : #{type} (#{contract_class.name})"
         puts "[debug]  self -> #{self}"
         value = instance_variable_get( :"@#{name}" )
         value
       end
      end # class_eval
    end # if

    puts "after - instance_methods:"
    pp contract_class.instance_methods( false )
end  # method getter_function


def self.mapping_getter_function( contract_class, name, type, 
                                         constant: false,
                                         immutable: false)
    ## note: make sure name is always a symbol
    name          = name.to_sym
    
    arguments = {}
    index = 0
    current_type = type

    sig_args = []
    while current_type.name == :mapping do
      arguments["arg#{index}".to_sym] = current_type.key_type.name
      sig_args << current_type.key_type.name
      current_type = current_type.value_type
      index += 1
    end


    ## auto-add/register sig(nature) in here - why? why not?
    puts "sig_args:"
    pp sig_args
    contract_class.sig( name, sig_args, :view, returns: current_type.name )
    
    puts "[debug]  auto-generate public mapping getter - #{name} : #{type} (#{contract_class.name}):"
    puts "    arguments:"
    pp   arguments
    puts "    index: #{index}"
# {:arg0=>:address}
#    index: 1
  
      contract_class.class_eval do
       ## note: hack: must use kwargs for now!!! arg0, arg1, arg2, for now
       define_method :"#{name}" do |arg0:, arg1: nil, arg2: nil, arg3: nil|
        puts "[debug] call public (state) mapping getter for #{name} : #{type} (#{contract_class.name})"
        puts "[debug]  self -> #{self}"
        args = [arg0, arg1, arg2, arg3]
        puts "[debug]  args -> #{args.pretty_print_inspect}"
     
        ## raise ArgumentError, "expected #{index} argument(s); got #{args.size}" if args.size != index

        value = instance_variable_get( "@#{name}" )
         (0...index).each do |i|
           value = value[ args[i] ]
         end
        value
       end
    end # class_eval
end  # method mapping_getter_function

end  # module Generator
