# Type Sig(natures) / Annotation


What syntax to use - while still following the "it's just ruby" idea / philosophy / principle?


i try to improve the method sig(nature) / type annotation using  the Module.method_added hook "metaprogramming magic". the idea is to drop / kill the duplicate method name, thus:


``` ruby
sig :transfer, [Address, UInt], returns: Bool
def transfer( to:, amount: )
  #...
end
```

becomes

``` ruby
sig  [Address, UInt], returns: Bool
def transfer( to:, amount: )
  #...
end 
```

i know method sig(nature) / type annotatation are ugly.   not sure if a "string" version is better?

``` ruby
sig '(Address, UInt) => Bool', 
def transfer( to:, amount: )
  #...
end 

#  @sig (Address, UInt) => Bool 
def transfer( to:, amount: )
  #...
end 
```

maybe this is possible?

``` ruby
def transfer( to: Address, amount: UInt, returns: Bool )
  #...
end
```

or adding the sig(nature) inline as last parameter? 

``` ruby
def transfer( to:, amount:,  sig: '(Address, UInt) => Bool' )
  #...
end
```

or with unicode magic types / sig(nature) encoded in name itself?

``` ruby
def transfer‹Address_UInt→Bool›( to:, amount: )
  #...
end
```



your ideas / suggestions here. yes, you can.
