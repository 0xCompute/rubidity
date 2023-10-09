# Rubidity - Hello World



<details>
<summary markdown="1">Solidity - Hello World</summary>

pragma specifies the compiler version of Solidity.

``` solidity
// SPDX-License-Identifier: MIT
// compiler version must be greater than or equal to 0.8.20 and less than 0.9.0
pragma solidity ^0.8.20;

contract HelloWorld {
    string public greet = "Hello World!";
}
```

</details>


Note: In Rubidity the pragma "magic comment" is optional for now (and reserved for later use).


``` ruby
# SPDX-License-Identifier: Public Domain
# pragma: rubidity 0.0.1

class HelloWorld < Contract  

   storage greet: String

   sig []
   def constructor
     @greet = "Hello World!"
   end
end
```

Note: In rubidity you CANNOT assign state (storage) variables
outside of functions. Use the constructor to assign your own (initial) values (if the values differ from the default zero initializaton values).   


## Try with Simulacrum

- [run_helloworld.rb](run_helloworld.rb)


