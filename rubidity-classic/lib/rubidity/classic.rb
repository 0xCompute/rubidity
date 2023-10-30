
require 'solidity/typed'
require 'rubidity'


## our own code
require_relative 'classic/version'  # let version always go first
require_relative 'classic/proc'
require_relative 'classic/builder'
require_relative 'classic/codegen'



###
# for easy use / convenience
#     pack everything into Contract.load( path/name ) 

class Contract
  def self.load( path, generate: true )

    source = Builder.load_file( path ).source
    pp source
    pp source.contracts
    
    puts "  #{source.contracts.size} contract(s) in source (unit):"
    source.contracts.each do |contract|
        print "   #{contract.name}"
        print " is #{contract.is.inspect}"   unless contract.is.empty?
        print "\n"
    end
    
    ####################
    ### generate contract classes
    source.generate   if generate
     
    source  ## return source (unit) - why? why not?   
  end
end   # class Contract



puts Rubidity::Module::Classic.banner     ## say hello
