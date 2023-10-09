# Notes on Types in Ruby

add a typed?  to Integer, String
and a typed?( UInt ) or typed?( Int )
or typed?( Address )
or typed?( Bytes32 ) or such







## More

check for contrained integers or types in ruby
 (possible with "plain" built-in classes??)

e.g. how to constrain integers to natural numbers (0,1,2,...) - what is out there?



## Dry-Types gem



https://dry-rb.org/gems/dry-types/1.7/

dry-types  - has contraints  also for integers e.g.
                 maybe only in structs??

attribute :age,  Types::Strict::Integer.constrained(gteq: 18)
end

User.new(name: 'Bob', age: 17)
# => Dry::Struct::Error: [User.new] 17 (Fixnum) has invalid type for :age




