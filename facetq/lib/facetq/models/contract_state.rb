# == Schema Information
#
# Table name: contract_states
#
#  id                :bigint           not null, primary key
#  transaction_hash  :string           not null
#  type              :string           not null
#  init_code_hash    :string           not null
#  state             :jsonb            not null
#  block_number      :bigint           not null
#  transaction_index :bigint           not null
#  contract_address  :string           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_contract_states_on_addr_block_number_tx_index             (contract_address,block_number,transaction_index) UNIQUE
#  index_contract_states_on_contract_address                       (contract_address)
#  index_contract_states_on_contract_address_and_transaction_hash  (contract_address,transaction_hash) UNIQUE
#  index_contract_states_on_state                                  (state) USING gin
#  index_contract_states_on_transaction_hash                       (transaction_hash)
#
# Foreign Keys
#
#  fk_rails_...  (block_number => eth_blocks.block_number) ON DELETE => cascade
#  fk_rails_...  (contract_address => contracts.address) ON DELETE => cascade
#  fk_rails_...  (transaction_hash => ethscriptions.transaction_hash) ON DELETE => cascade
#


class ContractState < ActiveRecord::Base
  self.inheritance_column = :_type_disabled
  
  belongs_to :contract, foreign_key: :contract_address, primary_key: :address, optional: true
  belongs_to :contract_transaction, foreign_key: :transaction_hash, primary_key: :transaction_hash, optional: true
  belongs_to :ethscription,
  primary_key: 'transaction_hash', foreign_key: 'transaction_hash',
  optional: true
  
  scope :newest_first, -> {
    order(block_number: :desc, transaction_index: :desc) 
  }
  
  def as_json(options = {})
    super(
      options.merge(
        only: [
          :transaction_hash,
          :contract_address,
          :state,
        ]
      )
    )
  end
end
