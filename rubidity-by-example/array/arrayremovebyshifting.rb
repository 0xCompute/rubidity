#  SPDX-License-Identifier: public domain
#  pragma: rubidity 0.0.1

class ArrayRemoveByShifting  < Contract  
    ## [1, 2, 3] -- remove(1) --> [1, 3, 3] --> [1, 3]
    ## [1, 2, 3, 4, 5, 6] -- remove(2) --> [1, 2, 4, 5, 6, 6] --> [1, 2, 4, 5, 6]
    ## [1, 2, 3, 4, 5, 6] -- remove(0) --> [2, 3, 4, 5, 6, 6] --> [2, 3, 4, 5, 6]
    ## [1] -- remove(0) --> [1] --> []

    storage arr: array( UInt )


    sig [UInt]
    def remove( index: )
        assert index < @arr.length, "index out of bound"

        i = index
        while i < @arr.length-1 do
           @arr[i] = @arr[i + 1]
           i += 1
        end
        @arr.pop
    end


    sig []
    def test
        @arr = Array‹UInt›.new( [1, 2, 3, 4, 5] )
        remove(2)
        ##  [1, 2, 4, 5]
        assert @arr[0] == 1 
        assert @arr[1] == 2 
        assert @arr[2] == 4 
        assert @arr[3] == 5 
        assert @arr.length == 4 

        @arr = Array‹UInt›.new( [1] )
        remove(0)
        ##  []
        assert @arr.length ==  0 
    end
end
