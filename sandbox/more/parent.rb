require 'pp'

class ContractImplementation
end

class ERC20 < ContractImplementation
   include Comparable 
   include Enumerable
end

class PublicMintERC20 < ERC20

 def self.linearized_parents  ## change to parent_contracts or such - why? why not?
    ## for now 
    ##    include all classes before ContractImplementation
    classes = []
    self.ancestors.each do |ancestor|
        break if ancestor == ContractImplementation
        if ancestor.instance_of?( Class )
            classes << ancestor 
        else  ### assume Module
            puts "[debug] skipping module - #{ancestor.name} : #{ancestor.class.name}"
        end
    end    
    classes[1..-1]   ## exclude self (that is, cut-off first class)
 end
end


pp PublicMintERC20
pp PublicMintERC20.ancestors
pp PublicMintERC20.linearized_parents
#=> [PublicMintERC20, 
#     ERC20, 
#     ContractImplementation, 
#     Object, 
#     PP::ObjectMixin, 
#     Kernel, BasicObject]


puts "bye"