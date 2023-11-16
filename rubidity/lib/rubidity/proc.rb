

class Proc
  ## add quick & dirty support for getting source!!!  

  ## use non-greed .*? to "slurp"-up everything to the end
  BLOCK_RX = /do 
               .*? 
              \n[ ]{0,2}end
              /xm

  def source   ## fix: change to contract_source - why? why not?
     filename, lineno = self.source_location
     lines = File.open( "contracts/#{filename}.rb", 'r:utf-8' ) { |f| f.readlines }
     ## up to 10 for now
     ## note: lineno is starting counting at 1 (use -1 for offset in ary)

     ## for now assume no method longer than 100 lines
     ## note: lines INCLUDEs newlines e.g.
     ##  ["  constructor(name: :string, symbol: :string, decimals: :uint8) do |name, symbol, decimals|\n",
     ##   "    puts \"ERC20.constructor\"\n",
     ##   "    @name = name\n",
     ##   "    @symbol = symbol\n",
     ##   "    @decimals = decimals\n",
     ##   "  end\n",

     pastie = lines[lineno-1, 100].join
     ## pp pastie
     
     ## use regex quick hack
     ##   to extract use first do
     ##  and end on its own line (with max indent of two spaces!!)
     m = BLOCK_RX.match( pastie )
     if m
        m[0][2..-1][0..-4]  ## return matched code - cut of do/end wrapper
     else
        raise  "sorry; no do-end match for code block source"
     end 
  end  
end


