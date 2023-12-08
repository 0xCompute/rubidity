# == Schema Information
#
# Table name: contract_artifacts
#
#  id                         :bigint           not null, primary key
#  transaction_hash           :string           not null
#  internal_transaction_index :bigint           not null
#  block_number               :bigint           not null
#  transaction_index          :bigint           not null
#  name                       :string           not null
#  source_code                :text             not null
#  init_code_hash             :string           not null
#  references                 :jsonb            not null
#  pragma_language            :string           not null
#  pragma_version             :string           not null
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#
# Indexes
#
#  idx_on_block_number_transaction_index_internal_tran_570359f80e  (block_number,transaction_index,internal_transaction_index) UNIQUE
#  idx_on_transaction_hash_internal_transaction_index_c95378cab3   (transaction_hash,internal_transaction_index) UNIQUE
#  index_contract_artifacts_on_init_code_hash                      (init_code_hash) UNIQUE
#  index_contract_artifacts_on_name                                (name)
#
# Foreign Keys
#
#  fk_rails_...  (block_number => eth_blocks.block_number) ON DELETE => cascade
#  fk_rails_...  (transaction_hash => ethscriptions.transaction_hash) ON DELETE => cascade
#


class ContractArtifact  < ActiveRecord::Base
  
  belongs_to :contract_transaction, foreign_key: :transaction_hash, primary_key: :transaction_hash, optional: true
  
  scope :newest_first, -> {
    order(
      block_number: :desc,
      transaction_index: :desc,
      internal_transaction_index: :desc
    ) 
  }
    
  def as_json(options = {})
    super(
      options.merge(
        only: [
          :name,
          :source_code,
          :init_code_hash
        ]
      )
    )
  end
end
