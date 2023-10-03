# SPDX-License-Identifier: MIT
# pragma: rubidity 0.0.1

class SimpleStorage < Contract  
    #  State variable to store a number
    storage num: UInt 

    sig :constructor, []
    def constructor
    end

    # You need to send a transaction to write to a state variable.
    sig :set, [UInt]
    def set(num: )
       @num = num
    end

    # You can read from a state variable without sending a transaction.
    sig :get, [], :view, returns: UInt
    def get
       @num
    end
end
