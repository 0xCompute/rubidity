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
name   = Typed::Var.new( :string ) 
symbol = Typed::Var.new( :string )

decimals    = Typed::Var.new( :uint256 ) 
totalSupply = Typed::Var.new( :uint256 )


:string # gets turned into
Typed::String.new  ## use singelton - why?

:uint256 # gets turned into
Typed::Uint256.new  ## use singelton - why?
```
