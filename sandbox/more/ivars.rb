###
# check if access of ivars possible in super class?


class ERC20

  def ctor( name:, symbol: )
     puts "ERC20#ivars:"
     pp instance_variables
     puts defined?( @name )
     puts defined?( @symbol )
     puts "ERC20#ctor:"
     pp @name
     pp @symbol

     @name   = name
     @symbol = symbol
  end

  def dump
     pp self
  end
end

class PublicERC20 < ERC20 

   def initialize
     @name   = 'name'
     @symbol = 'symbol'
     @mintLimit = 11
   end

 
   def ctor( name:, symbol: )
      super
      puts "PublicERC20#ctor:"
      pp @name
      pp @symbol

      puts "PublicERC20#ivars:"
      pp instance_variables      
   end 
end


o = PublicERC20.new
pp o
pp o.dump
o.ctor( name: 'n1', symbol: 's1' )
pp o

puts "bye"