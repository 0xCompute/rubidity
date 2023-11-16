#  SPDX-License-Identifier: Public Domain


class Counter < Contract
    storage count: UInt

  
    # Function to get the current count
    sig [], :view, returns: UInt
    def get
      @count
    end

    # Function to increment count by 1
    sig []
    def inc
       @count += 1
    end

    # Function to decrement count by 1
    sig []
    def dec
      # This function will fail if count = 0
      @count -= 1
    end
end
