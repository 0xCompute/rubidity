# Types


try a simpler version for types and easier to (re)use



``` ruby
string :public, :name
string :public, :symbol

uint256 :public, :decimals    
uint256 :public, :totalSupply  
```


allow "stand-alone" by-hand use e.g

``` ruby
name   = TypedVar.new( :string, :public, :name ) 
symbol = TypedVar.new( :string, :public, :symbol )

decimals    = TypedVar.new( :uint256, :public, :decimals ) 
totalSupply = TypedVar.new( :uint256, :public, :totalSupply )


:string # gets turned into
Typed::String  ## use singelton - why?

:uint256 # gets turned into
Typed::Uint256  ## use singelton - why?
```
