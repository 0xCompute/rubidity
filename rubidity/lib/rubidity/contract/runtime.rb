### use a differet name? why? why not?
###   Runtime__ or Runtime ___ ???


module RuntimeHelper    
    
  ### keep assert here - why? why not?
  ##    use AssertHelper or ErrorHelper or ...    
  ##
  ## note: change from require to assert
  ##         to avoid confusion with ruby require - why? why not?
  def assert(condition, message='no message')
    unless condition
      # caller_location = caller_locations.detect { |l| l.path.include?('/app/models/contracts') }
      # file = caller_location.path.gsub(%r{.*app/models/contracts/}, '')
      # line = caller_location.lineno
      
      error_message = "#{message}"     ##. (#{file}:#{line})"
      ## todo/fix: change to (built-in) ???Error, ....
      ##  check for error to raise for assertion fail??
      raise error_message
    end
  end
   

  ## note: for now this is just the solidity alias/used name
  ##  for ruby's self  - anything missing - why? why not?
  ##  - to get the address - use address( this ) 
  def this()  self; end


  ## todo/check: change current_transaction to tx - why? why not?  
  def current_transaction()  Runtime.current_transaction; end
 
  def msg()                  Runtime.msg; end
  def block()                Runtime.block; end

  def log( event_klass, *args, **kwargs )

    raise "event class expected; got: >#{event_klass.inspect}<; sorry"  unless event_klass.ancestors.include?( Types::Event)
    
    rec = if kwargs.size > 0
            event_klass.new( **kwargs )
          else
            event_klass.new( *args )
          end
    data = rec.as_data   ## "serialize" to "plain" types
    
    current_transaction.log_event( { event: event_klass.name, 
                                     data:  data })
  end

end  # module RuntimeHelper

