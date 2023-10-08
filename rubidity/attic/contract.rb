

 ####
 # events
 def self.event( name, args )
    ## todo/fix:
    ## assume pairs of symbol and hash (args)
    ##   allow declarations of more than one event !!!

    @events ||= {}
    name = name.to_sym  ## note: make sure name is ALWAYS a symbol
    ## note assume args is a hash
    ##     change typedclasses to type (defs)
    @events[name] = args.map do |key,value|  
                             [
                               key,
                               typeof( value )
                             ]  
                           end.to_h


  end

  def self.events
    @events || {}
  end


  def log( event_name, args = {} )
  event_name = event_name.to_sym  ## note: make sure event_name is ALWAYS as symbol
  unless self.class.events.key?( event_name)
    raise NameError, "Event #{event_name} is not defined in this contract."
  end

  expected_args = self.class.events[event_name]
  missing_args = expected_args.keys - args.keys
  extra_args   = args.keys - expected_args.keys

  if missing_args.any? || extra_args.any?
    error_messages = []
    error_messages << "Missing arguments for #{event_name} event: #{missing_args.join(', ')}." if missing_args.any?
    error_messages << "Unexpected arguments provided for #{event_name} event: #{extra_args.join(', ')}." if extra_args.any?
    raise ArgumentError, error_messages.join(' ')
  end


  current_transaction.log_event({ event: event_name, data: args })
end




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

