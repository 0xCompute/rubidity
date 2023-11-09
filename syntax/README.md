# More Rubidity (O.G. / Classic or "More Ruby-ish") Syntax Ideas / Extensions



##  turn :uint into uint / UInt or :address into address / Address or :string into string / String

Use global type functions (conversion functions WITHOUT arguments)
to turn symbols or class constants into lowercase type names.

``` ruby
def string()  :string; end    # or
def string()  Types::String; end

def address()  :address; end  # or
def address()  Types::Address; end

# and so on
```

to use turn:

``` ruby
  function :createProduct, { ownerId: :uint32,
                             modelNumber: :string,
                             partNumber: :string,
                             serialNumber: :string,
                             productCost: :uint32 }, :public, returns: :uint32 do     

```

into

``` ruby
  function :createProduct, { ownerId: uint32,
                             modelNumber: string,
                             partNumber: string,
                             serialNumber: string,
                             productCost: uint32 }, :public, returns: uint32 do     
```



