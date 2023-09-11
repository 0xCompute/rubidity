

class TypedMapping < TypedReference

    ## todo/check: make "internal" data/hash available? why? why not?
    attr_reader :data   

    def initialize( value = nil, key_type:, value_type: )
      @type = Type.create( :mapping, key_type: key_type,
                                     value_type: value_type )
      puts
      puts "[debug] TypedMapping#initialize - #{type.inspect}, #{value.inspect}"

      replace( value || {} )            
      puts "[debug] data: #{@data.inspect}"
    end
    def zero?() @data == {}; end  ## use @data.empty? - why? why not?


    def replace( new_value )  ### add/use alias assign / set / or ___ or such - why? why?
        @data = if new_value.is_a?( TypedVariable )
                   if new_value.type != @type
                     raise TypeError, "expected type #{type}; got #{new_value.type} : #{new_value.value}"
                   end
                   new_value.data
                else
                    type.check_and_normalize_literal( new_value ).map do |key, value|
                        [
                          type.key_type.create( key ),
                          type.value_type.create( value )
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
      def value=(new_value) 
        puts "[warn] do NOT use TypedMapping#value=(new_value); will get removed? SOON?" 
        replace( new_value ) 
      end
    

  ## add more Hash forwards here!!!!
  extend Forwardable   ## pulls in def_delegator
  def_delegators :@data, :size, :empty?, :clear


  ##
   ### todo/fix: do NOT store typed keys and values in hash!!!!
   ##   (maybe only if array or mapping but NOT for primitivies!!!!)
   def [](key)
    puts "[debug] []( #{key} )"
    key_var =  key.is_a?( TypedVariable ) ? key : type.key_type.create( key )
    obj = @data[key_var]

    if type.value_type.is_a?( MappingType ) && obj.nil?
      obj = type.value_type.zero
      @data[key_var] = obj
    end

    obj || type.value_type.zero 
  end


  def []=(key, new_value)
    puts "[debug] []=( #{key}:#{key.class.name}, #{new_value}:#{new_value.class.name})"
    pp type.key_type
    key_var = key.is_a?( TypedVariable ) ? key : type.key_type.create( key )
    pp key_var
    obj     = new_value.is_a?( TypedVariable) ? new_value : type.value_type.create( new_value )
    pp obj

    if type.value_type.is_a?( MappingType )
      ## val_var = Proxy.new(keytype: valuetype.keytype, valuetype: valuetype.valuetype)
      raise "What?"
    end

    @data[key_var] = obj
  end

 

  ## note: pass through value!!!!
  ##   in new scheme - only "plain" ruby arrays/hash/string/integer/bool used!!!!
  ##    no wrappers!!! - no need to convert!!!
  def serialize
    puts "[debug] TypedMapping#serialize"
    @data.reduce({}) do |h, (k, v)|
        h[k.serialize] = v.serialize
        h
    end
  end
end  # class TypedMapping

