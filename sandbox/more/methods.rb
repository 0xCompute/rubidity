##########
#  check how to get instance_method if overwritten

class String
    def demodulize
        path = self
        path = path.to_s
        if i = path.rindex('::')
          path[(i+2)..-1]
        else
          path
        end
    end
end  # class String
  

module Contracts
class A

   def hello( msg )
      puts self.class.name
      puts "calling A#hello_old #{msg}"
   end
   ## note: MUST add prefix for rename for alias_method!!!
   alias_method :__A__hello, :hello
   def hello( msg )
    puts "calling A#hello #{msg}"
       send( :__A__hello, msg )
   end
   alias_method :A, :hello  ## constructor-like
end


class B < A
    def hello( msg )
      puts self.class.name
      puts "calling B#hello_old #{msg}"
    end
    alias_method :__B__hello, :hello
    def hello( msg )
        puts "calling B#hello #{msg}"
        super( "mundo" )  ## change arg for testing
        A( "welt" )
        send( :__B__hello, msg )
    end
 end
end  #  module Contracts


 b = Contracts::B.new
 pp b 
 puts b.hello( 'world' )


 puts "bye"