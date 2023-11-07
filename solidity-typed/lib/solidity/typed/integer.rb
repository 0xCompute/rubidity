###
#  integer exponential and ether money unit extensions / helper
#
#  include via module - why? why not?


class Integer
    def e2()  self * 10**2; end   #                       100
    def e3()  self * 10**3; end   #                      1000
    def e4()  self * 10**4; end   #                    10_000
    def e5()  self * 10**5; end   #                   100_000
    def e6()  self * 10**6; end   #                 1_000_000
    def e7()  self * 10**7; end   #                10_000_000
    def e8()  self * 10**8; end   #               100_000_000
    def e9()  self * 10**9; end   #             1_000_000_000
    def e10() self * 10**10; end  #            10_000_000_000
    def e11() self * 10**11; end  #           100_000_000_000
    def e12() self * 10**12; end  #         1_000_000_000_000
    def e13() self * 10**13; end  #        10_000_000_000_000
    def e14() self * 10**14; end  #       100_000_000_000_000
    def e15() self * 10**15; end  #     1_000_000_000_000_000
    def e16() self * 10**16; end  #    10_000_000_000_000_000
    def e17() self * 10**17; end  #   100_000_000_000_000_000
    def e18() self * 10**18; end  # 1_000_000_000_000_000_000
    def e19() self * 10**19; end
    def e20() self * 10**20; end
    def e21() self * 10**21; end
    def e22() self * 10**22; end
    def e23() self * 10**23; end
    def e24() self * 10**24; end  # 1_000_000_000_000_000_000_000_000

    ###########
    # Ethereum money units
    #  add more - why? why not?
    def ether()   self * e18; end
    alias_method :eth, :ether
  
end # class Integer
  
  


