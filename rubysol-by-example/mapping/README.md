# Rubysol - Mapping

Maps are created with the syntax `mapping(keyType, valueType)`.

The `keyType` can be any built-in value type, bytes, string, or any contract.

`valueType` can be any type including another mapping or an array.

Mappings are not iterable.

<details>
<summary markdown="1">Solidity - Mapping</summary>

``` solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Mapping {
    // Mapping from address to uint
    mapping(address => uint) public myMap;

    function get(address _addr) public view returns (uint) {
        // Mapping always returns a value.
        // If the value was never set, it will return the default value.
        return myMap[_addr];
    }

    function set(address _addr, uint _i) public {
        // Update the value at this address
        myMap[_addr] = _i;
    }

    function remove(address _addr) public {
        // Reset the value to the default value.
        delete myMap[_addr];
    }
}

contract NestedMapping {
    // Nested mapping (mapping from address to another mapping)
    mapping(address => mapping(uint => bool)) public nested;

    function get(address _addr1, uint _i) public view returns (bool) {
        // You can get values from a nested mapping
        // even when it is not initialized
        return nested[_addr1][_i];
    }

    function set(address _addr1, uint _i, bool _boo) public {
        nested[_addr1][_i] = _boo;
    }

    function remove(address _addr1, uint _i) public {
        delete nested[_addr1][_i];
    }
}
```

</details>


```ruby
# SPDX-License-Identifier: public domain


class MappingBasic < Contract

    # Mapping from address to uint
    storage myMap: mapping( Address, UInt )


    sig [Address], :view, returns: UInt 
    def get( addr: ) 
        # Mapping always returns a value.
        # If the value was never set, it will return the default value.
        @myMap[ addr ]
    end

    sig [Address, UInt]
    def set( addr:, i: )
        # Update the value at this address
        @myMap[ addr ] = i
    end

    sig [Address]
    def remove( addr: )
        # Reset the value to the default value.
        @myMap.delete( addr )
    end
end

class NestedMapping < Contract 
    #  Nested mapping (mapping from address to another mapping)
    storage nested: mapping(Address, mapping( UInt, Bool))

    sig [Address, UInt], :view, returns: Bool
    def get( addr1:, i: ) 
        # You can get values from a nested mapping
        # even when it is not initialized
        @nested[ addr1 ][ i ]
    end

    sig [Address, UInt, Bool]
    def set( addr1:, i:, bool: )
        @nested[ addr1 ][ i ] = bool
    end

    sig [Address, UInt]
    def remove( addr1:, i: ) 
        @nested[ addr1 ].delete( i )
    end
end
```

