# SPDX-License-Identifier: MIT
# pragma: rudidity 0.0.1

class ArrayReplaceFromEnd  < Contract 
    
    storage arr: array( UInt )

  
    ## Deleting an element creates a gap in the array.
    ## One trick to keep the array compact is to
    ## move the last element into the place to delete.

    sig [UInt]
    def remove( index: ) 
        # Move the last element into the place to delete
        @arr[ index ] = @arr[ @arr.length - 1 ]
        ## Remove the last element
        @arr.pop
    end

    sig []
    def test
        @arr =  Array‹UInt›.new( [1, 2, 3, 4] )

        remove(1)
        #  [1, 4, 3]
        assert @arr.length == 3
        assert @arr[0] == 1
        assert @arr[1] == 4
        assert @arr[2] == 3

        remove(2)
        #  [1, 4]
        assert @arr.length == 2
        assert @arr[0] == 1
        assert @arr[1] == 4
    end
end
