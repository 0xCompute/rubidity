# == Schema Information
#
# Table name: transaction_receipts
#
#  id                         :bigint           not null, primary key
#  transaction_hash           :string           not null
#  from_address               :string           not null
#  status                     :string           not null
#  function                   :string
#  args                       :jsonb            not null
#  logs                       :jsonb            not null
#  block_timestamp            :bigint           not null
#  error                      :jsonb
#  to_contract_address        :string
#  effective_contract_address :string
#  created_contract_address   :string
#  block_number               :bigint           not null
#  transaction_index          :bigint           not null
#  block_blockhash            :string           not null
#  return_value               :jsonb
#  runtime_ms                 :integer          not null
#  call_type                  :string           not null
#  gas_price                  :bigint
#  gas_used                   :bigint
#  transaction_fee            :bigint
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#
# Indexes
#
#  index_contract_tx_receipts_on_block_number_and_tx_index    (block_number,transaction_index) UNIQUE
#  index_transaction_receipts_on_block_number                 (block_number)
#  index_transaction_receipts_on_block_number_and_runtime_ms  (block_number,runtime_ms)
#  index_transaction_receipts_on_created_contract_address     (created_contract_address)
#  index_transaction_receipts_on_effective_contract_address   (effective_contract_address)
#  index_transaction_receipts_on_runtime_ms                   (runtime_ms)
#  index_transaction_receipts_on_to_contract_address          (to_contract_address)
#  index_transaction_receipts_on_transaction_hash             (transaction_hash) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (block_number => eth_blocks.block_number) ON DELETE => cascade
#  fk_rails_...  (transaction_hash => ethscriptions.transaction_hash) ON DELETE => cascade
#


class TransactionReceipt < ActiveRecord::Base 
  belongs_to :eth_block, foreign_key: :block_number, primary_key: :block_number

  belongs_to :contract, primary_key: 'address', foreign_key: 'effective_contract_address', optional: true
  belongs_to :contract_transaction, foreign_key: :transaction_hash, primary_key: :transaction_hash, optional: true

  belongs_to :ethscription,
  primary_key: 'transaction_hash', foreign_key: 'transaction_hash',
  optional: true
  
  scope :newest_first, -> { order(block_number: :desc, transaction_index: :desc) }
  scope :oldest_first, -> { order(block_number: :asc, transaction_index: :asc) }

  
  def contract
    Contract.find_by_address(address)
  end
  
  def address
    effective_contract_address
  end
  
  def to
    to_contract_address
  end
  
  def from
    from_address
  end
  
  def contract_address
    created_contract_address
  end

  def to_or_contract_address
    to || contract_address
  end
  
  def as_json(options = {})
    super(
      options.merge(
        only: [
          :transaction_hash,
          :call_type,
          :runtime_ms,
          :block_timestamp,
          :status,
          :function,
          :args,
          :error,
          :logs,
          :block_blockhash,
          :block_number,
          :transaction_index,
          :gas_price,
          :gas_used,
          :transaction_fee,
          :return_value,
          :effective_contract_address
        ],
        methods: [:to, :from, :contract_address, :to_or_contract_address]
      )
    ).with_indifferent_access
  end
  
  def failure?
    status.to_s == 'failure'
  end
  
  def success?
    status.to_s == 'success'
  end
end
