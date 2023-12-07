
## check if applicationrecord works
##            in actierecord "stand-alone" mode??


class EthBlock <  ActiveRecord::Base   #  ApplicationRecord

  has_many :ethscriptions, foreign_key: :block_number, primary_key: :block_number
  has_many :transaction_receipts, foreign_key: :block_number, primary_key: :block_number
  
  scope :newest_first, -> { order(block_number: :desc) }
  scope :oldest_first, -> { order(block_number: :asc) }
  
  scope :processed, -> { where.not(processing_state: "pending") }
  
  def self.max_processed_block_number
    EthBlock.processed.maximum(:block_number).to_i
  end

  
  
  def as_json(options = {})
    super(options.merge(
      only: [
        :block_number,
        :timestamp,
        :blockhash,
        :parent_blockhash,
        :imported_at,
        :processing_state,
        :transaction_count,
      ]
    )).tap do |json|
      if association(:transaction_receipts).loaded?
        json[:transaction_receipts] = transaction_receipts.map(&:as_json)
      end
    end.with_indifferent_access
  end
end
