# == Schema Information
#
# Table name: contract_transactions
#
#  id                :bigint           not null, primary key
#  transaction_hash  :string           not null
#  block_blockhash   :string           not null
#  block_timestamp   :bigint           not null
#  block_number      :bigint           not null
#  transaction_index :bigint           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_contract_transactions_on_transaction_hash  (transaction_hash) UNIQUE
#  index_contract_txs_on_block_number_and_tx_index  (block_number,transaction_index) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (block_number => eth_blocks.block_number) ON DELETE => cascade
#  fk_rails_...  (transaction_hash => ethscriptions.transaction_hash) ON DELETE => cascade
#


class ContractTransaction < ActiveRecord::Base
  
  belongs_to :ethscription, primary_key: :transaction_hash, foreign_key: :transaction_hash, optional: true
  has_one :transaction_receipt, foreign_key: :transaction_hash, primary_key: :transaction_hash
  has_many :contract_states, foreign_key: :transaction_hash, primary_key: :transaction_hash
  has_many :contract_calls, foreign_key: :transaction_hash, primary_key: :transaction_hash, inverse_of: :contract_transaction
  has_many :contracts, foreign_key: :transaction_hash, primary_key: :transaction_hash
  has_many :contract_artifacts, foreign_key: :transaction_hash, primary_key: :transaction_hash

  attr_accessor :tx_origin, :payload
  
  def self.transaction_mimetype
    "application/vnd.facet.tx+json"
  end
  
  
  
  
  def status
    contract_calls.any?(&:failure?) ? :failure : :success
  end
end
