# == Schema Information
#
# Table name: contracts
#
#  id                     :bigint           not null, primary key
#  transaction_hash       :string           not null
#  block_number           :bigint           not null
#  transaction_index      :bigint           not null
#  current_type           :string
#  current_init_code_hash :string
#  current_state          :jsonb            not null
#  address                :string           not null
#  deployed_successfully  :boolean          not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  idx_on_address_deployed_successfully                  (address) UNIQUE WHERE (deployed_successfully = true)
#  index_contracts_on_address                            (address) UNIQUE
#  index_contracts_on_current_init_code_hash             (current_init_code_hash)
#  index_contracts_on_current_state                      (current_state) USING gin
#  index_contracts_on_current_type                       (current_type)
#  index_contracts_on_deployed_successfully              (deployed_successfully)
#  index_contracts_on_deployed_successfully_and_address  (deployed_successfully,address) UNIQUE
#  index_contracts_on_transaction_hash                   (transaction_hash)
#
# Foreign Keys
#
#  fk_rails_...  (block_number => eth_blocks.block_number) ON DELETE => cascade
#  fk_rails_...  (transaction_hash => ethscriptions.transaction_hash) ON DELETE => cascade
#


class Contract <  ActiveRecord::Base

  has_many :states, primary_key: 'address', foreign_key: 'contract_address', class_name: "ContractState"
  belongs_to :contract_transaction, foreign_key: :transaction_hash, primary_key: :transaction_hash, optional: true

  belongs_to :ethscription, primary_key: 'transaction_hash', foreign_key: 'transaction_hash', optional: true
  
  has_many :contract_calls, foreign_key: :effective_contract_address, primary_key: :address
  has_one :transaction_receipt, through: :contract_transaction

 
  
  after_initialize :set_normalized_initial_state
  
  def set_normalized_initial_state
    @normalized_initial_state = JsonSorter.sort_hash(current_state)
  end
  
  def normalized_state_changed?
    @normalized_initial_state != JsonSorter.sort_hash(current_state)
  end
  
    
  def as_json(options = {})
    super(
      options.merge(
        only: [
          :address,
          :transaction_hash,
          :current_init_code_hash,
          :current_type
        ]
      )
    ).tap do |json|
      
      if association(:transaction_receipt).loaded?
        json['deployment_transaction'] = transaction_receipt
      end
      
      json['current_state'] = if options[:include_current_state]
        current_state
      else
        {}
      end
      
      json['current_state']['contract_type'] = current_type    
    end
  end
end
