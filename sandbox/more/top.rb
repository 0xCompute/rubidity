###
#  check if top level name conflict (Array, String)

module Types
   RubyString = ::String
   RubyArray  = ::Array
   pp RubyString 
   pp RubyArray  
   pp RubyString.ancestors
   pp RubyArray.ancestors

   class Typed; end
   class String < Typed; end
   class Array < Typed; end

   pp String 
   pp Array  
   pp String.new.inspect
   pp Array.new.inspect
   pp String.ancestors
   pp Array.ancestors
   pp RubyString.inspect 
   pp RubyArray.inspect  
   pp RubyString.new 
   pp RubyArray.new  
   pp RubyString.ancestors
   pp RubyArray.ancestors
end

T = Types
TypedString = Types::String



module Typed
   include Types

   pp Typed
   pp String
   pp Array
   pp TypedString
end
 
pp TypedString
pp String


__END__
# module Typed
include Typed

pp Types::Typed
pp Types::Array
pp Types::Typed.name
pp Types::Array.name
puts "-- String"
pp String
puts "-- Array"
pp Array
puts "-- T::String"
pp T::String
puts "-- T::Array"
pp T::Array
pp String.name
pp Array.name
puts "-- ::String"
pp ::String
puts "-- ::Array"
pp ::Array

puts "-- ::String.new"
pp ::String.new
pp T::String.new

## pp ancestors

## end

__END__

puts "-----------------"

include Types

pp RubyString
pp RubyArray
pp RubyString.new
pp RubyArray.new
pp RubyString.ancestors
pp RubyArray.ancestors

pp ::String.new
pp ::Array.new
pp String.new.inspect
pp Array.new.inspect



__END__

pp Typed
pp String
pp Array
pp Typed.name
pp String.name
pp Array.name
pp Typed.ancestors
pp String.ancestors
pp Array.ancestors

## note: NOT working - still Typed
pp ::String.ancestors
pp ::Array.ancestors


puts "bye"