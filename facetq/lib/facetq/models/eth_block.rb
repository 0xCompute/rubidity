# == Schema Information
#
# Table name: eth_blocks
#
#  id                :bigint           not null, primary key
#  block_number      :bigint           not null
#  timestamp         :bigint           not null
#  blockhash         :string           not null
#  parent_blockhash  :string           not null
#  imported_at       :datetime         not null
#  processing_state  :string           not null
#  transaction_count :bigint
#  runtime_ms        :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_eth_blocks_on_block_number                      (block_number) UNIQUE
#  index_eth_blocks_on_block_number_completed            (block_number) WHERE ((processing_state)::text = 'complete'::text)
#  index_eth_blocks_on_block_number_pending              (block_number) WHERE ((processing_state)::text = 'pending'::text)
#  index_eth_blocks_on_blockhash                         (blockhash) UNIQUE
#  index_eth_blocks_on_imported_at                       (imported_at)
#  index_eth_blocks_on_imported_at_and_processing_state  (imported_at,processing_state)
#  index_eth_blocks_on_parent_blockhash                  (parent_blockhash) UNIQUE
#  index_eth_blocks_on_processing_state                  (processing_state)
#  index_eth_blocks_on_timestamp                         (timestamp)
#


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
