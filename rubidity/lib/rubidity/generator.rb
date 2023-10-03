

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


def self.typecheck( type, value )
    ##   check if value is already typed?
    if value.is_a?( Types::Typed )
       ## type check
       raise TypeError, "type #{type} expected; got #{value.pretty_print_inspect}"  unless type == value.type
       value
    else
        ## assume "literal" value
        type.create( value )
    end
end

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
                              typecheck( type, value )
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
                    [key, typecheck( type, value)]
                end.to_h
              else
                ## assume no args - e.g. construct - double check for empty input spec/def!!!
                if inputs.empty?
                  {}   
                else
                  raise ArgumentError, "Array (args) or Hash (kwargs) required for func call; sorry"
                end
              end

    unless kwargs.empty?          
      puts "#{kwargs.size} kwarg(s):"
      pp kwargs
    end
    
    kwargs
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
               ## if name == :constructor  ### add ERC20() or such
               ##   alias_method contract_name, :"__#{contract_name}__#{name}"
               ## end
               ##  - use leading underscore - why? why not? e.g. _ERC20()
               ##        as alternative to NOT conflict with global conversion function - why? why not?
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
      contract_class.sig( name, [Types::Typed::UIntType.instance], :view, returns: type.sub_type )

      contract_class.class_eval do
        ## note: hack: must use kwargs for now!!! index: (not index) for now
        define_method name do |index:|
          puts "[debug] call public (state) array getter for #{name} : #{type} with index #{index} (#{contract_class.name})"
          puts "[debug]  self -> #{self}"
          value = instance_variable_get( :"@#{name}" )
          value[index]   
        end
      end # class_evel
    else
      puts "[debug] auto-generate public getter - #{name} : #{type}:"

      ## auto-add/register sig(nature) in here - why? why not?
      contract_class.sig( name, [], :view, returns: type )

      contract_class.class_eval do
       define_method name do
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
    
    index = 0
    current_type = type

    sig_args = []
    while current_type.mapping? do
      sig_args << current_type.key_type
      current_type = current_type.value_type
      index += 1
    end

    
    puts "[debug]  auto-generate public mapping getter - #{name} : #{type} (#{contract_class.name}):"
    puts "sig_args:"
    pp sig_args
    ## auto-add/register sig(nature) in here - why? why not?
    contract_class.sig( name, sig_args, :view, returns: current_type)
    puts "    index: #{index}"
# {:arg0=>:address}
#    index: 1
  
      contract_class.class_eval do
       ## note: hack: must use kwargs for now!!! arg0, arg1, arg2, for now
       define_method name do |arg0:, arg1: nil, arg2: nil, arg3: nil|
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



##
#  add global contract function to lookup AND typecheck
##          contracts using  Contract.at 
##   add via Module and Kernel - why? why not?        
module Globals
end  # module Globals

## todo/check: move Kernel include to  rubidity.rb script (with requires) - why? why not?
::Kernel.include( Globals )

def self.global_function( contract_class )
  ## todo/check: check if method exists already - why? why not?

  contract_name = _demodulize( contract_class.name ).to_sym   

  ## use module_eval if exists? why? why not?
  ## example:
  ##  def ERC20( address )
  ##    klass = ERC20
  ##    puts "==> calling #{klass.name}( #{address.pretty_print_inspect })"
  ##    obj = klass.at( address )
  ##    raise ArgumentError, "no #{klass.name} contract @ addreess #{address} found; sorry"   if obj.nil?
  ##    puts "  bingo! #{obj.class.name} (#{obj.class.parent_contracts}) contract found @ #{address}"
  ##    obj
  ##  end  
  Globals.class_eval do
   define_method contract_name do |address|
      klass = contract_class
      puts "==> calling #{klass.name}( #{address.pretty_print_inspect })"
      obj = klass.at( address )
      raise ArgumentError, "no #{klass.name} contract @ address #{address} found; sorry"   if obj.nil?
      puts "  bingo! #{obj.class.name} (#{obj.class.parent_contracts}) contract found @ #{address}"
      obj
   end
  end
end
end  # module Generator

