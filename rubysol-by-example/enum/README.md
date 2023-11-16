# Rubysol - Enum


Rubysol supports enumerables and they are useful to model choice and keep track of state.


```ruby
# SPDX-License-Identifier: public domain


class EnumBasic < Contract
    # Enum representing shipping status
    enum :Status,
           :pending,
           :shipped,
           :accepted,
           :rejected,
           :canceled
    

    # Default value is the first element listed in
    #  definition of the type, in this case "Pending"
    storage  status: Status 

    # Returns uint
    #  Pending  - 0
    #  Shipped  - 1
    #  Accepted - 2
    #  Rejected - 3
    #  Canceled - 4
    sig [], :view, returns: Status
    def get
      @status
    end

    #  Update status by passing uint into input
    sig [Status]
    def set( status: ) 
      @status = status
    end

    #  You can update to a specific enum like this
    sig []
    def cancel
      @status = Status.canceled
    end

    # delete resets the enum to its first value, 0
    sig []
    def reset
       @status = Status.min   ## or Status.zero
    end
end
```


## Try with Simulacrum

- [run_enum.rb](run_enum.rb)
