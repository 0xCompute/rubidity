# Rubidity - Array

Array can have a compile-time fixed size or a dynamic size.

<details>
<summary markdown="1">Solidity - Array</summary>

``` solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Array {
    // Several ways to initialize an array
    uint[] public arr;
    uint[] public arr2 = [1, 2, 3];
    // Fixed sized array, all elements initialize to 0
    uint[10] public myFixedSizeArr;

    function get(uint i) public view returns (uint) {
        return arr[i];
    }

    // Solidity can return the entire array.
    // But this function should be avoided for
    // arrays that can grow indefinitely in length.
    function getArr() public view returns (uint[] memory) {
        return arr;
    }

    function push(uint i) public {
        // Append to array
        // This will increase the array length by 1.
        arr.push(i);
    }

    function pop() public {
        // Remove last element from array
        // This will decrease the array length by 1
        arr.pop();
    }

    function getLength() public view returns (uint) {
        return arr.length;
    }

    function remove(uint index) public {
        // Delete does not change the array length.
        // It resets the value at index to it's default value,
        // in this case 0
        delete arr[index];
    }

    function examples() external {
        // create array in memory, only fixed size can be created
        uint[] memory a = new uint[](5);
    }
}
```

``` solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ArrayRemoveByShifting {
    // [1, 2, 3] -- remove(1) --> [1, 3, 3] --> [1, 3]
    // [1, 2, 3, 4, 5, 6] -- remove(2) --> [1, 2, 4, 5, 6, 6] --> [1, 2, 4, 5, 6]
    // [1, 2, 3, 4, 5, 6] -- remove(0) --> [2, 3, 4, 5, 6, 6] --> [2, 3, 4, 5, 6]
    // [1] -- remove(0) --> [1] --> []

    uint[] public arr;

    function remove(uint _index) public {
        require(_index < arr.length, "index out of bound");

        for (uint i = _index; i < arr.length - 1; i++) {
            arr[i] = arr[i + 1];
        }
        arr.pop();
    }

    function test() external {
        arr = [1, 2, 3, 4, 5];
        remove(2);
        // [1, 2, 4, 5]
        assert(arr[0] == 1);
        assert(arr[1] == 2);
        assert(arr[2] == 4);
        assert(arr[3] == 5);
        assert(arr.length == 4);

        arr = [1];
        remove(0);
        // []
        assert(arr.length == 0);
    }
}
```

``` solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ArrayReplaceFromEnd {
    uint[] public arr;

    // Deleting an element creates a gap in the array.
    // One trick to keep the array compact is to
    // move the last element into the place to delete.
    function remove(uint index) public {
        // Move the last element into the place to delete
        arr[index] = arr[arr.length - 1];
        // Remove the last element
        arr.pop();
    }

    function test() public {
        arr = [1, 2, 3, 4];

        remove(1);
        // [1, 4, 3]
        assert(arr.length == 3);
        assert(arr[0] == 1);
        assert(arr[1] == 4);
        assert(arr[2] == 3);

        remove(2);
        // [1, 4]
        assert(arr.length == 2);
        assert(arr[0] == 1);
        assert(arr[1] == 4);
    }
}
```

</details>



``` ruby
#  SPDX-License-Identifier: public domain
# pragma: rubidity 0.0.1

class ArrayBasic   < Contract

  ## Several ways to initialize an array
  ## Fixed sized array, all elements initialize to 0 
  storage arr:            array( UInt ),
          arr2:           array( UInt ),
          myFixedSizeArr: array( UInt, 10 )
    
   sig []
   def constructor
      @arr2 =  [1, 2, 3]  
   end   

    sig [UInt], :view, returns: UInt
    def get( i ) 
       @arr[i]
    end

    ## Rubidity can return the entire array.
    ##  But this function should be avoided for
    ## arrays that can grow indefinitely in length.
    sig [], :view, returns: array( UInt )
    def getArr 
        @arr
    end

    sig [UInt]
    def push( i )
        ## Append to array
        ## This will increase the array length by 1.
        @arr.push( i )
    end

    sig [], returns: UInt
    def pop
        ## Remove last element from array
        ## This will decrease the array length by 1
        @arr.pop()
    end

    sig [], :view, returns: UInt
    def getLength
        @arr.length
    end

    sig [UInt]
    def remove(index:) 
        # Delete does not change the array length.
        # It resets the value at index to it's default value,
        # in this case 0
        @arr.delete( index )
    end

    sig []
    def examples
        ##  create array in memory, only fixed size can be created
        a =  Array( UInt, 5 ).new    ## new uint[](5);
    end
end
```


### Examples of removing array element

Remove array element by shifting elements from right to left

``` ruby
#  SPDX-License-Identifier: public domain
#  pragma: rubidity 0.0.1

class ArrayRemoveByShifting  < Contract  
    ## [1, 2, 3] -- remove(1) --> [1, 3, 3] --> [1, 3]
    ## [1, 2, 3, 4, 5, 6] -- remove(2) --> [1, 2, 4, 5, 6, 6] --> [1, 2, 4, 5, 6]
    ## [1, 2, 3, 4, 5, 6] -- remove(0) --> [2, 3, 4, 5, 6, 6] --> [2, 3, 4, 5, 6]
    ## [1] -- remove(0) --> [1] --> []

    storage arr: array( UInt )
 

    sig [UInt]
    def remove( index )
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
```


Remove array element by copying last element into to the place to remove

``` ruby
# SPDX-License-Identifier: MIT
# pragma: rudidity 0.0.1

class ArrayReplaceFromEnd  < Contract 
    
    storage arr: array( UInt )

  
    ## Deleting an element creates a gap in the array.
    ## One trick to keep the array compact is to
    ## move the last element into the place to delete.

    sig [UInt]
    def remove( index ) 
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
```


## Try with Simulacrum

- [run_arrays.rb](run_arrays.rb)



