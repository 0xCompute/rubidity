###
# to run use
#  $ ruby  sandbox/state.rb

require_relative '../types'
require_relative '../typed_vars'



class StateProxy
    attr_reader :state

    def initialize(defs)
      @state = {}
      defs.each do |name, var|
        @state[name.to_s] = var
      end
    end
    
    def method_missing(name, *args)
      is_setter = name[-1] == '='
      var_name = is_setter ? name[0...-1].to_s : name.to_s
      
      puts "[debug] method_missing  var_name: #{var_name}, is_setter: #{is_setter}"
      var = state[var_name]
      ## pp var
      
      return super if var.nil?
      
      return var unless is_setter
        
      var.value = args.first
     end
    
    def serialize
      state.each.with_object({}) do |(key, value), h|
        h[key] = value.serialize
      end
    end
    
    def deserialize(state_data)
      state_data.each do |var_name, value|
        state[var_name].deserialize(value)
      end
    end
    alias_method :load, :deserialize
end


###
# try state proxy-lke

statevars = [ 
  [:name,        Typed.var( :string )],
  [:symbol,      Typed.var( :string )],
  [:decimals,    Typed.var( :uint256 )],    
  [:totalSupply, Typed.var( :uint256 )],
  [:balanceOf,   Typed.var( :mapping, keytype: :addressOrDumbContract,
                                      valuetype: :uint256) ],
]

pp statevars


s = StateProxy.new( statevars )
pp s


puts "serialize:"
pp s.serialize

s.name   = 'My Fun Token'
s.symbol = 'FUN'
s.decimals = 18
s.totalSupply = 21000000 

pp s.serialize

pp s.balanceOf


puts "try array access"
pp s.balanceOf[ '0xC2172a6315c1D7f6855768F843c420EbB36eDa97' ] 
pp s.balanceOf[ '0xC2172a6315c1D7f6855768F843c420EbB36eDa97' ].value 
# = 21000000


puts "bye"
