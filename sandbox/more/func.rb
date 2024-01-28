require 'ostruct'


FUNCS = {}

def func( name, **kwargs, &block )
    pp kwargs
    args = kwargs.keys
    pp args

    puts "func - self: #{self.inspect}"

    code = proc { |a,b|
                     pp [a,b]
                     block.call( a, b ) 
                }
  
    define_method :"#{name}_unsafe" do |a,b|
       puts "==> calling #{name}_unsafe"
       puts "  args: #{[a,b].inspect}"
       puts "  self: #{self.inspect}"
  
       ctx = OpenStruct.new( a: a, b: b )
 
       ## ctx.instance_exec( 3, 4, &block )
       ## block.call( a, b )
       ## code.call( a: a, b: b )
       block.call( a: a, b: b )
    end

    puts "method #{name}_unsafe added"
end



func :add, a: Integer, b: Integer do |**kwargs|   ## |a,b|
    puts "kwargs: #{kwargs.inspect}"
    a + b
end



pp add_unsafe( 4, 2 )