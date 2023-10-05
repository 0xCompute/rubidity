
module Types
class Mapping < TypedReference

    ## add short-cut helpers why? why not?
    def key_type() self.class.type.key_type; end
    def value_type() self.class.type.value_type; end

    ## todo/check: make "internal" data/hash available? why? why not?
    attr_reader :data   

    def initialize( initial_value = {} )
      ## was: initial_value ||= {}             
      ##     check if nil gets passed in - default not used?  
 
      raise ArgumentError, "expected literal of type #{type}; got typed #{initial_value.pretty_print_inspect}"    if initial_value.is_a?( Typed )    
 
        @data =     type.check_and_normalize_literal( initial_value ).map do |key, value|
                        [
                          type.key_type.new( key ),
                          type.value_type.new( value )
                        ]
                      end.to_h
    end

    def zero?() @data == {}; end  ## use @data.empty? - why? why not?



  extend Forwardable   ## pulls in def_delegator
  ## add more Hash forwards here!!!!
  def_delegators :@data, :size, :empty?, :clear



  def [](key)
    puts "[debug] Mapping#[]( #{key} )"
    key_var =  key.is_a?( Typed ) ? key : key_type.new( key )
    obj = @data[key_var]

    ## was:
    ## if value_type.mapping? && obj.nil?
    ##  obj = 
    ##  @data[key_var] = obj
    ## end
    ##
    ## note:
    ##  change to 
    ## allow access to ref to struct and than update change to assign !!=!!!!!!
  
    if obj.nil?
      obj = value_type.new_zero
      @data[ key_var ] = obj
    end

    obj 
  end



  def []=(key, new_value)
    puts "[debug] Mapping#[]=( #{key}:#{key.class.name}, #{new_value}:#{new_value.class.name})"
    pp type.key_type
    key_var = key.is_a?( Typed ) ? key : key_type.new( key )
    pp key_var
    obj     = new_value.is_a?( Typed ) ? new_value : value_type.new( new_value )
    pp obj

    if value_type.mapping?
      ## val_var = Proxy.new(keytype: valuetype.keytype, valuetype: valuetype.valuetype)
      raise 'What?'
    end

    @data[key_var] = obj
  end


  def key?( key )
    key_var =  key.is_a?( Typed ) ? key : key_type.new( key )
    @data.key?( key_var )
  end
  alias_method :has_key?, :key?  

  def delete( key )
    key_var =  key.is_a?( Typed ) ? key : key_type.new( key )
    @data.delete( key_var )
  end

  
  ## note: pass through value!!!!
  ##   in new scheme - only "plain" ruby arrays/hash/string/integer/bool used!!!!
  ##    no wrappers!!! - no need to convert!!!
  def as_data
    puts "[debug] Mapping#as_data"
    @data.reduce({}) do |h, (k, v)|
      ## todo/fix:
      ##   check if value is zero/ do not serialize zero - why? why not?
        h[k.as_data] = v.as_data
        h
    end
  end

  def pretty_print( printer ) 
    printer.text( "<ref #{type}:#{@data.pretty_print_inspect}>" ); 
  end
end  # class Mapping
end  # module Types

