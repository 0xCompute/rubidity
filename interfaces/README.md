# Interfaces - How To Model (Solidity) Interfaces in Rubyidity?

Option 1)

Interfaces. No thanks.

Option 2)

Let's try:


``` solidity
interface IERC20 {
    function totalSupply() external view returns (uint);

    function balanceOf(address account) external view returns (uint);

    function transfer(address recipient, uint amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint amount);
    event Approval(address indexed owner, address indexed spender, uint amount);
}
```

and the "more ruby-ish" rubidity version (draft):



``` ruby
module IERC20 
   sig  :totalSupply, {}, :view, returns: UInt
   sig  :balanceOf, {account: Address}, :view, returns: UInt
   sig  :transfer,  {recipient: Address, 
                     amount: UInt }, returns: Bool
   sig  :allowance, {owner: Address, 
                     spender: Address}, :view, returns: UInt
   sig  :approve,  { spender: Address,
                     amount: Uint }, returns: Bool
   sig  :transferFrom, { sender: Address,
                         recipient: Address,
                         amount:  UInt },  returns: Bool


    event :Transfer, { from:   Address, # indexed 
                       to:     Address, # indexed
                       amount: UInt }
    event :Approval, { owner:   Address, # indexed 
                       spender: Address, #  indexed 
                       amount:  UInt }
end
```

what's happening behind the scence?

The function sig(natures) get (auto-)added to the module attribute sigs.
Try:

``` ruby
IERC20.sigs
```

to get the sig(natures) supported by IERC20.

and the event get turned into TypedEvent classes (via an event class builder) and set as consant in the module e.g.

``` ruby
IERC20::Transfer    ## gets you the Transfer event class
IERC20::Approval    ## gets you the Approval event class 
```

and how to use in contracts?  use include. example:


``` ruby
class ERC20 < Contract
   include IERC20
   # ...
end
```

or maybe let's alias include to is why? why not?

``` ruby
class ERC20 < Contract
   is IERC20
   # ...
end
```



or maybe with with blocks more "soliditity-ish":

``` ruby
interface :IERC20 do
   # ...
end

contract :ERC20  do
  is :IERC20 
   # ...
end
```



