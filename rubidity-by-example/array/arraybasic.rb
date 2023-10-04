#  SPDX-License-Identifier: public domain
# pragma: rubidity 0.0.1

class ArrayBasic   < Contract

  ## Several ways to initialize an array
  ## Fixed sized array, all elements initialize to 0 
  storage arr:            array( UInt ),
          arr2:           array( UInt ),
          myFixedSizeArr: array( UInt, 10 )
    
   sig :constructor, []
   def constructor
      @arr2 = Array‹UInt›.new( [1, 2, 3] ) 
   end   

    sig :get, [UInt], :view, returns: UInt
    def get( i: ) 
       @arr[i]
    end

    ## Solidity can return the entire array.
    ##  But this function should be avoided for
    ## arrays that can grow indefinitely in length.
    sig :getArr, [], :view, returns: array( UInt )
    def getArr 
        @arr
    end

    sig :push, [UInt] 
    def push( i: )
        ## Append to array
        ## This will increase the array length by 1.
        @arr.push( i )
    end

    sig :pop, [], returns: UInt
    def pop
        ## Remove last element from array
        ## This will decrease the array length by 1
        @arr.pop()
    end

    sig :getLength, [], :view, returns: UInt
    def getLength
        @arr.length
    end

    sig :remove, [UInt]
    def remove(index:) 
        # Delete does not change the array length.
        # It resets the value at index to it's default value,
        # in this case 0
        @arr.delete( index )
    end

    sig :examples, []
    def examples
        ##  create array in memory, only fixed size can be created
        a =  array( UInt, 5 ).new    ## new uint[](5);
    end
end
