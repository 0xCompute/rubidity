##
# try if float money unit monkey patch possible?
#   e.g.  0.5.ether => 500000000... 

class Integer
    def e6() self *10**6; end
    def e17() self *10**17; end
    def e24() self *10**24; end

    def ether() self *10**18; end
    alias_method :eth, :ether
end

class Float
    def e18() (self *10**18).to_i; end

    ## note: add e6 (zeros) after conversion to int
    def e24() (self *10**18).to_i.e6; end

    def ether() (self *10**18).to_i; end
    alias_method :eth, :ether
end



pp 0.5.ether
pp 1.5.ether
pp 2.5.ether
pp 0.25.ether

pp 0.5.e18
pp 1.5.e18
pp 2.5.e18
pp 0.25.e18


pp 0.5.ether ==  5.e17
pp 1.5.ether == 15.e17


pp 21.e24
pp 21.0.e24
pp 21e24.to_i
pp 21.999.e24
pp 21.333.e24


puts "bye"