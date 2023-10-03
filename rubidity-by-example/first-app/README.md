# Rubidity - First App



<details>
<summary markdown="1">Solidity - First App</summary>

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Counter {
    uint public count;

    // Function to get the current count
    function get() public view returns (uint) {
        return count;
    }

    // Function to increment count by 1
    function inc() public {
        count += 1;
    }

    // Function to decrement count by 1
    function dec() public {
        // This function will fail if count = 0
        count -= 1;
    }
}

</details>



``` ruby
#  SPDX-License-Identifier: MIT
# pragma: rubidity 0.0.1

class Counter < Contract
    storage count: UInt

    # Function to get the current count
    sig [], :view, returns: UInt,
    def get
      @count
    end

    # Function to increment count by 1
    sig [],
    def inc
       @count += 1
    end

    # Function to decrement count by 1
    sig [],
    def dec
      # This function will fail if count = 0
      @count -= 1
    end
end
```


## Try with Simulacrum

- [run_counter.rb](run_counter.rb)
