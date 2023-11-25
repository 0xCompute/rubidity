
module ScribeDb
    module Model
  
  class Tx < ActiveRecord::Base
    self.table_name = 'txs'   ## note auto-infers txes change to txs

    belongs_to :inscribe, foreign_key: 'id'
=begin    
    def text
       content.force_encoding(Encoding::UTF_8)
    end
=end
  end  # class Tx
  
    end # module Model
end # module ScribeDb
  