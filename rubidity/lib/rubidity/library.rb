
module Library

  def self.extended(base)
    puts "==> turn (extend) module >#{base.name}< into library"
    base.include( Types )  ## make solidity types availbe (Address, Bytes, etc.)
    base.extend( ClassMethods )
    ## todo/fix: add  runtime and crypto methods too? why? why not? 
  end


  module ClassMethods
    def struct( class_name, **attributes )
      typedclass = Types::Struct.new( class_name, scope: self, **attributes )
      typedclass  
    end
    
    def enum( class_name, *args )
      typedclass = Types::Enum.new( class_name, *args, scope: self  )
      typedclass
    end
    
####
#   note:  sig machinery with method_added MUST come last here
def sigs
  @sigs ||= {}
end

def sigs_unnamed   ## unnamed sigs stack 
  @sigs_unnamed ||= []
end 

## ignore this methods; 
##   do NOT (auto-)generate wrapper method popping (unnamed) sig from stack!!!   
def sigs_exclude
  ## note: always exclude  globals
  ##        get or can get changed via runtime modules (simulacrm) and such!!!
  ##  e.g. msg.sender, block.timestamp, tx.origin, etc. 
  @sigs_exclude ||= [:block, :tx, :msg]
end



def sig( args=[], *options, returns: nil )

  puts "[debug] add sig args: #{args.inspect}, options: #{options.inspect}, returns: #{returns.inspect}"
  ## use inputs for args) and outputs for returns  - why? why not?

  ## check if include explicit visibility in options
  if  options.include?( :public ) ||
      options.include?( :private ) ||
      options.include?( :internal )
      # do nothing / pass-along as is
  else
      # auto-add default up-front - :public or :internal if name starting with underscore (_)
      visibility =  name.start_with?( '_' )  ? :internal : :public
      options.unshift( visibility )
  end

  ####  
  #  auto-convert args (inputs), returns (outputs) to type (defs)
  args = args.map { |value| typeof( value ) }

  ###
  ## note: turn returns into an array - empty if nil, etc.
  ##        always wrap into array
  returns =  if returns.nil?
                  []
             elsif returns.is_a?( ::Array ) 
                  returns 
             else  ## assume single type
                  [returns]  
             end  

  returns = returns.map { |value| typeof( value ) }


  @sigs_unnamed ||= [] 
  @sigs_unnamed.push( { inputs:  args,
                        outputs: returns,
                        options: options } )
end



def method_added( name )

  if sigs_exclude.include?( name )
     puts "--- skip method added hook >#{name}< - found in sigs exclude"
     return ## do nothing; 
  else
     puts "==> method added hook >#{name}<... processing..."
  end

  ## pp name
  ## pp name.class.name

  name = name.to_sym  ## note: make sure name is ALWAYS a symbol

  ## note:  method lookup via method needs an object / INSTANCE
  ##             NOT working with class only!!!!
 
  # m = method( name )
  # pp m.name
  # pp m.parameters
  # pp m

  raise "no unnamed sig(nature) on stack for method >#{name}< in module >#{self.name}<; sorry"   if sigs_unnamed.size == 0
  sig_unnamed = sigs_unnamed.pop  
  puts "    using sig_unnamed: #{sig_unnamed.inspect}"
  

  @sigs ||= {}
  raise "duplicate method sig(nature) for method >#{name}< in module >#{self.name}<; sorry"   if @sigs.has_key?( name )
  @sigs[ name ] = sig_unnamed



  puts "    generate typed_library_function >#{name}<"
  Generator.typed_library_function( self, name, 
                                      inputs: sig_unnamed[ :inputs ] )  

  puts "<== method added hook >#{name}< done."                               
end
end # module ClassMethods
end  # module Library
