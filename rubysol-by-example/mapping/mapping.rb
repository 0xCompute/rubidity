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
