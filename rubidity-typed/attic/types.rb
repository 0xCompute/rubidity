class Type


 ## note: deprecated old types - get removed SOON!
 XXX_TYPES = [:dumbContract, :addressOrDumbContract]

 def self.create( type_or_name, **kwargs )

   when :dumbContract           then DumbContractType.instance
   when :addressOrDumbContract  then AddressOrDumbContractType.instance 

 end

 def check_and_normalize_literal( literal )


   elsif is_a?( AddressOrDumbContractType )
    unless literal.is_a?(::String) && (literal.match?(/^0x[a-f0-9]{64}$/i) || literal.match?(/^0x[a-f0-9]{40}$/i))
      raise_type_error(literal)
    end

    ## note: always downcase & freeze address - why? why not?
    return [ADDRESS_ZERO, CONTRACT_ZERO].include?( literal ) ? literal : literal.downcase.freeze


 end


end  # class Type



class AddressOrDumbContractType < ValueType  ## note: use "generic" "union" type???
    def name() :addressOrDumbContract; end
    def format() 'addressOrDumbContract'; end
   
## todo: check what to do for AddressOrDumbContract
##       allow union? (e.g. Address and DumbContract) too
##            or only AddressOrDumbContract???
      def ==(other)
        other.is_a?( AddressOrDumbContractType ) 
        ##  other.is_a?( AddressOrDumbContractType ) ||
        ##  other.is_a?( AddressType ) || 
        ##  other.is_a?( DumbContractType ) 
      end
    def zero()  ADDRESS_ZERO;  end  # note: default is address(0)
    
    alias_method :to_s,          :format
    alias_method :default_value, :zero

    def self.instance()  @instance ||= new; end

    #####
    #  add create helper - why? why not?    
    def create( initial_value=ADDRESS_ZERO ) TypedAddressOrDumbContract.new( initial_value ); end 
end



