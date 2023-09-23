##
# to run use:
#   $ ruby sandbox/state.rb



$LOAD_PATH.unshift( "./lib" )
require 'rubidity/typed'



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
      
      if is_setter
        var.replace( args.first )
      else
        var
      end
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
  [:name,        TypedVariable.create( :string )],
  [:symbol,      TypedVariable.create( :string )],
  [:decimals,    TypedVariable.create( :uint256 )],    
  [:totalSupply, TypedVariable.create( :uint256 )],
  [:balanceOf,   TypedVariable.create( :mapping, key_type: :address,
                                                 value_type: :uint256) ],
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


pp s.name
pp s.symbol
pp s.decimals
pp s.balanceOf


puts "try array access"
pp s.balanceOf[ '0xC2172a6315c1D7f6855768F843c420EbB36eDa97' ]  
# = 21000000

s.balanceOf[ '0xC2172a6315c1D7f6855768F843c420EbB36eDa97' ] = 21000000 
pp s.balanceOf[ '0xC2172a6315c1D7f6855768F843c420EbB36eDa97' ]  


old_state =  s.serialize
pp old_state


s.deserialize( old_state )
pp s
pp s.serialize


puts "bye"
