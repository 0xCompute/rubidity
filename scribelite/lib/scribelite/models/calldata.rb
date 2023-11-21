
module ScribeDb
    module Model
  
  class Calldata < ActiveRecord::Base
    self.table_name = 'calldatas'   ## check if infers data? why? why not?

    belongs_to :inscribe, foreign_key: 'id'

=begin    
    def text
       content.force_encoding(Encoding::UTF_8)
    end
=end
  end  # class Calldata
  
    end # module Model
end # module ScribeDb
  