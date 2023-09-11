# Notes on Types (v2)

try a simpler version for types and easier to (re)use
while keeping the same module & classes names and attributes for
kind-of "drop-in" replacement.


## todos

fix -   safemapping and safearray ALWAYS return "wrapped" TypedVariable objects!!!




## more

try a simpler version for types and easier to (re)use


``` ruby
string :public, :name
string :public, :symbol

uint256 :public, :decimals    
uint256 :public, :totalSupply  
```


allow "stand-alone" by-hand use e.g

``` ruby
name   = TypedString.new 
symbol = TypedString.new

decimals    = TypedUint256.new 
totalSupply = TypedUint256.new


:string # gets turned into
StringType.instance  ## singelton for type info  - why?
# and variable into
TypedString.new   

:uint256 # gets turned into
Uint256Type.instance  ## singelton for type info - why?
# and variable into
TypedUint256.new  
```
