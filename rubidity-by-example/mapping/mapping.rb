# SPDX-License-Identifier: public domain
# pragma: rubidity 0.0.1


class MappingBasic < Contract

    #  Mapping from address to uint
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
