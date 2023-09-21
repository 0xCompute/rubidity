
class HashWithIndifferentAccess   ## simple hash with indifferent acccess; symbolize keys
    def initialize( initial_value = {} )
       @data = initial_value
    end
    
    def [](key)         @data[ key.to_sym ]; end
    def []=(key, value) @data[ key.to_sym] = value; end 
 
    def to_hash() @data; end
 
 
    def merge( *other_hashes )
       other_hashes = other_hashes.map do |other| 
                              other.is_a?(HashWithIndifferentAccess) ? other.to_hash : other 
                       end  
       HashWithIndifferentAccess.new( @data.merge( *other_hashes ))
    end
 
    extend Forwardable   ## pulls in def_delegators
    def_delegators :@data,  :each, :size, 
                            :select, :key?,
                            :reduce,
                            :empty?, :==, :<=> 
 end # class HashWithIndifferentAccess
 