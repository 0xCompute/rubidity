

def self.sig( name, args=[], *options, returns: nil )
  puts "[debug] add sig #{name} args: #{args.inspect}, options: #{options.inspect}, returns: #{returns.inspect}"
  @sigs ||= {}
  name = name.to_sym  ## note: make sure name is ALWAYS a symbol
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
  args = args.map do |value|  
       typeof( value )
  end

  returns = typeof( returns )   if returns

  
  @sigs[name] = { inputs:  args,
                  outputs: returns,
                  options: options }
end

