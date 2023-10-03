# Rubidity - Reading and Writing to a State Variable


To write or update a state variable you need to send a transaction.

On the other hand, you can read state variables, for free, without any transaction fee.


<details>
<summary markdown="1">Solidity - Hello World</summary>

``` solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SimpleStorage {
    // State variable to store a number
    uint public num;

    // You need to send a transaction to write to a state variable.
    function set(uint _num) public {
        num = _num;
    }

    // You can read from a state variable without sending a transaction.
    function get() public view returns (uint) {
        return num;
    }
}
```

</details>



``` ruby
# SPDX-License-Identifier: Public Domain
# pragma: rubidity 0.0.1

class SimpleStorage < Contract  
    #  State variable to store a number
    storage num: UInt 

    # You need to send a transaction to write to a state variable.
    sig [UInt],
    def set(num: )
       @num = num
    end

    # You can read from a state variable without sending a transaction.
    sig [], :view, returns: UInt,
    def get
       @num
    end
end
```


## Try with Simulacrum

- [run_simplestorage.rb](run_simplestorage.rb)
