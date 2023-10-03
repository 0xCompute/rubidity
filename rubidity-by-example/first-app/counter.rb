#  SPDX-License-Identifier: Public Domain
# pragma: rubidity 0.0.1

class Counter < Contract
    storage count: UInt

    sig :constructor, []
    def constructor
    end

    # Function to get the current count
    sig :get, [], :view, returns: UInt
    def get
      @count
    end

    # Function to increment count by 1
    sig :inc, []
    def inc
       @count += 1
    end

    # Function to decrement count by 1
    sig :[]
    def dec
      # This function will fail if count = 0
      @count -= 1
    end
end
