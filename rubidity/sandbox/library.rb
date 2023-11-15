####
# to run use:
#   $ ruby sandbox/library

require_relative 'helper'


module LibHello
    extend Library
    include Types   ## todo/fix: auto-include if possible via Library!!!

    sig []
    def hello
      puts 'hello'
    end
 
    sig []
    def hi
       puts 'hi'
    end

    sig [String]
    def greet( name: )
        puts "Hello, #{name}!"
    end
end  # module LibHello



LibHello.hello
LibHello.hi

LibHello.greet( name: 'World' )
LibHello.greet( 'World' )



puts "bye"