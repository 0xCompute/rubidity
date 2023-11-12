# how to deal with library??
#  use module (inside Contract) now

module LibMath

    # @dev Calculates partial value given a numerator and denominator rounded down.
    #      Reverts if rounding error is >= 0.1%
    # @param numerator Numerator.
    # @param denominator Denominator.
    # @param target Value to calculate partial of.
    # @return partialAmount value of target rounded down.

    # sig [UInt, UInt, UInt], :pure, returns: UInt  # returns partialAmount
    def self.safeGetPartialAmountFloor(
        numerator:,
        denominator:,
        target:
    ) 
        if isRoundingErrorFloor(numerator, denominator, target) 
            revert("rounding error")
        end
        numerator * target / denominator
    end

    # @dev Checks if rounding error >= 0.1% when rounding down.
    # @param numerator Numerator.
    # @param denominator Denominator.
    # @param target Value to multiply with numerator/denominator.
    # @return isError Rounding error is present.
   
    # sig [UInt, UInt, UInt], :pure, returns: Bool
    def self.isRoundingErrorFloor(
        numerator:,
        denominator:,
        target: 
    )
        if denominator == 0 
            revert("division by zero")
        end

        # The absolute rounding error is the difference between the rounded
        # value and the ideal value. The relative rounding error is the
        # absolute rounding error divided by the absolute value of the
        # ideal value. This is undefined when the ideal value is zero.
        #
        # The ideal value is `numerator * target / denominator`.
        # Let's call `numerator * target % denominator` the remainder.
        # The absolute error is `remainder / denominator`.
        #
        # When the ideal value is zero, we require the absolute error to
        # be zero. Fortunately, this is always the case. The ideal value is
        # zero iff `numerator == 0` and/or `target == 0`. In this case the
        # remainder and absolute error are also zero.
        if target == 0 || numerator == 0 
            return false
        end

        # Otherwise, we want the relative rounding error to be strictly
        # less than 0.1%.
        # The relative error is `remainder / (numerator * target)`.
        # We want the relative error less than 1 / 1000:
        #        remainder / (numerator * target)  <  1 / 1000
        # or equivalently:
        #        1000 * remainder  <  numerator * target
        # so we have a rounding error iff:
        #        1000 * remainder  >=  numerator * target
        
        
        # -fix-fix-fix-
        # remainder = mulmod(
        #    target,
        #    numerator,
        #    denominator
        # )
        remainder = 9999  # -fix-fix-fix get/add mulmod function from safemath?? !!!!
        
        isError = remainder * 1000  >= numerator * target
    end
end
