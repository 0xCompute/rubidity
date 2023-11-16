# SPDX-License-Identifier: Public Domain


class SimpleStorage < Contract  
    #  State variable to store a number
    storage num: UInt 

 
    # You need to send a transaction to write to a state variable.
    sig [UInt]
    def set(num: )
       @num = num
    end

    # You can read from a state variable without sending a transaction.
    sig [], :view, returns: UInt
    def get
       @num
    end
end
