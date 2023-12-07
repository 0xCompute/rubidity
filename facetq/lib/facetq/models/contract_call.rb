# == Schema Information
#
# Table name: contract_calls
#
#  id                         :bigint           not null, primary key
#  transaction_hash           :string           not null
#  internal_transaction_index :bigint           not null
#  from_address               :string           not null
#  to_contract_address        :string
#  created_contract_address   :string
#  effective_contract_address :string
#  function                   :string
#  args                       :jsonb            not null
#  call_type                  :string           not null
#  return_value               :jsonb
#  logs                       :jsonb            not null
#  error                      :jsonb
#  status                     :string           not null
#  block_number               :bigint           not null
#  block_timestamp            :bigint           not null
#  block_blockhash            :string           not null
#  transaction_index          :bigint           not null
#  start_time                 :datetime         not null
#  end_time                   :datetime         not null
#  runtime_ms                 :integer          not null
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#
# Indexes
#
#  idx_on_block_number_txi_internal_txi                (block_number,transaction_index,internal_transaction_index) UNIQUE
#  idx_on_tx_hash_internal_txi                         (transaction_hash,internal_transaction_index) UNIQUE
#  index_contract_calls_on_call_type                   (call_type)
#  index_contract_calls_on_created_contract_address    (created_contract_address) UNIQUE
#  index_contract_calls_on_effective_contract_address  (effective_contract_address)
#  index_contract_calls_on_from_address                (from_address)
#  index_contract_calls_on_internal_transaction_index  (internal_transaction_index)
#  index_contract_calls_on_status                      (status)
#  index_contract_calls_on_to_contract_address         (to_contract_address)
#
# Foreign Keys
#
#  fk_rails_...  (block_number => eth_blocks.block_number) ON DELETE => cascade
#  fk_rails_...  (transaction_hash => ethscriptions.transaction_hash) ON DELETE => cascade
#
class ContractCall  < ActiveRecord::Base  # ApplicationRecord
  
 
  attr_accessor :to_contract, :salt, :pending_logs, :to_contract_init_code_hash, :to_contract_source_code
  
  belongs_to :created_contract, class_name: 'Contract', primary_key: 'address', foreign_key: 'created_contract_address', optional: true
  belongs_to :called_contract, class_name: 'Contract', primary_key: 'address', foreign_key: 'to_contract_address', optional: true
  belongs_to :effective_contract, class_name: 'Contract', primary_key: 'address', foreign_key: 'effective_contract_address', optional: true
  
  belongs_to :contract_transaction, foreign_key: :transaction_hash, primary_key: :transaction_hash, optional: true, inverse_of: :contract_calls
  
  belongs_to :ethscription, primary_key: 'transaction_hash', foreign_key: 'transaction_hash', optional: true
  
  scope :newest_first, -> { order(
    block_number: :desc,
    transaction_index: :desc,
    internal_transaction_index: :desc
  ) }

  
  
  
  def contract_nonce
    in_memory = contract_transaction.contract_calls.count do |call|
      call.from_address == from_address &&
      call.is_create? &&
      call.success?
    end
    
    scope = ContractCall.where(
      from_address: from_address,
      call_type: :create,
      status: :success
    )
    
    in_memory + scope.count
  end
  
  def eoa_nonce
    scope = ContractCall.where(
      from_address: from_address,
      call_type: [:create, :call]
    )
    
    scope.count
  end
  
  def current_nonce
    raise "Not possible" unless is_create?
    
    contract_initiated? ? contract_nonce : eoa_nonce
  end
  
  def contract_initiated?
    internal_transaction_index > 0
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
          :block_blockhash,
          :block_timestamp,
          :block_number,
          :transaction_index,
          :internal_transaction_index,
          :function,
          :args,
          :call_type,
          :return_value,
          :logs,
          :error,
          :status,
          :runtime_ms,
          :effective_contract_address
        ],
        methods: [:to, :from, :contract_address, :to_or_contract_address]
      )
    )
  end
  
  def calculated_runtime_ms
    (end_time - start_time) * 1000
  end
  
  def is_static_call?
    call_type.to_s == "static_call"
  end
  
  def is_create?
    call_type.to_s == "create"
  end
  
  def is_call?
    call_type.to_s == "call"
  end
  
  def failure?
    status.to_s == 'failure'
  end
  
  def success?
    status.to_s == 'success'
  end
  
  
end
