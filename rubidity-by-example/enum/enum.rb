# SPDX-License-Identifier: public domain
# pragma: rubidity 0.0.1


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


    sig :constructor, []
    def constructor
    end

    # Returns uint
    #  Pending  - 0
    #  Shipped  - 1
    #  Accepted - 2
    #  Rejected - 3
    #  Canceled - 4
    sig :get, [], :view, returns: Status 
    def get
      @status
    end

    #  Update status by passing uint into input
    sig :set, [Status]
    def set( status: ) 
      @status = status
    end

    #  You can update to a specific enum like this
    sig :cancel, []
    def cancel
      @status = Status.canceled
    end

    # delete resets the enum to its first value, 0
    sig :reset, []
    def reset
       @status = Status.min   ## or Status.zero
    end
end
