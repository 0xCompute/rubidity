

class TypedMapping < TypedReference

    ## add short-cut helpers why? why not?
    def key_type() self.class.type.key_type; end
    def value_type() self.class.type.value_type; end

    ## todo/check: make "internal" data/hash available? why? why not?
    attr_reader :data   

    def initialize( initial_value = nil )
      replace( initial_value || {} )            
      # puts "[debug] data: #{@data.inspect}"
    end
    def zero?() @data == {}; end  ## use @data.empty? - why? why not?


    def replace( new_value )  ### add/use alias assign / set / or ___ or such - why? why?
        @data = if new_value.is_a?( Typed )
                   if new_value.type != type
                     raise TypeError, "expected type #{type}; got #{new_value.pretty_print_inspect}"
                   end
                   new_value.data
                else
                    type.check_and_normalize_literal( new_value ).map do |key, value|
                        [
                          type.key_type.new( key ),
                          type.value_type.new( value )
                        ]
                      end.to_h
                end
    end

      ## change to ref or reference - why? why not?
      ##  or better remove completely? why? why not?
      def value()
        puts "[warn] do NOT use TypedMapping#value; will get removed? SOON?" 
        self
      end    
    

  ## add more Hash forwards here!!!!
  def_delegators :@data, :size, :empty?, :clear

  def [](key)
    puts "[debug] TypedMapping#[]( #{key} )"
    key_var =  key.is_a?( Typed ) ? key : key_type.new( key )
    obj = @data[key_var]

    if value_type.is_a?( MappingType ) && obj.nil?
      obj = value_type.new_zero
      @data[key_var] = obj
    end

    ## todo/fix-fix-fix:  access allows to ref to struct and than update change to assign !!=!!!!!!
    obj || value_type.new_zero 
  end


  def []=(key, new_value)
    puts "[debug] TypedMapping#[]=( #{key}:#{key.class.name}, #{new_value}:#{new_value.class.name})"
    pp type.key_type
    key_var = key.is_a?( Typed ) ? key : key_type.new( key )
    pp key_var
    obj     = new_value.is_a?( Typed ) ? new_value : value_type.new( new_value )
    pp obj

    if value_type.is_a?( MappingType )
      ## val_var = Proxy.new(keytype: valuetype.keytype, valuetype: valuetype.valuetype)
      raise 'What?'
    end

    @data[key_var] = obj
  end

 

  ## note: pass through value!!!!
  ##   in new scheme - only "plain" ruby arrays/hash/string/integer/bool used!!!!
  ##    no wrappers!!! - no need to convert!!!
  def serialize
    puts "[debug] TypedMapping#serialize"
    @data.reduce({}) do |h, (k, v)|
      ## todo/fix:
      ##   check if value is zero/ do not serialize zero - why? why not?
        h[k.serialize] = v.serialize
        h
    end
  end

  def pretty_print( printer ) 
    printer.text( "<ref #{type}:#{@data.pretty_print_inspect}>" ); 
  end
end  # class TypedMapping

