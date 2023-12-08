# == Schema Information
#
# Table name: ethscriptions
#
#  id                :bigint           not null, primary key
#  transaction_hash  :string           not null
#  block_number      :bigint           not null
#  block_blockhash   :string           not null
#  transaction_index :bigint           not null
#  creator           :string           not null
#  initial_owner     :string           not null
#  block_timestamp   :bigint           not null
#  content_uri       :text             not null
#  mimetype          :string           not null
#  processed_at      :datetime
#  processing_state  :string           not null
#  processing_error  :string
#  gas_price         :bigint
#  gas_used          :bigint
#  transaction_fee   :bigint
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_ethscriptions_on_block_number_and_transaction_index  (block_number,transaction_index) UNIQUE
#  index_ethscriptions_on_processing_state                    (processing_state)
#  index_ethscriptions_on_transaction_hash                    (transaction_hash) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (block_number => eth_blocks.block_number) ON DELETE => cascade
#


class Ethscription  <  ActiveRecord::Base
  
  belongs_to :eth_block, foreign_key: :block_number, primary_key: :block_number, optional: true

  has_many :contracts, primary_key: 'transaction_hash', foreign_key: 'transaction_hash'
 
  has_one :transaction_receipt, primary_key: 'transaction_hash', foreign_key: 'transaction_hash'

  has_one :contract_transaction, primary_key: 'transaction_hash', foreign_key: 'transaction_hash'
  has_one :system_config_version, primary_key: 'transaction_hash', foreign_key: 'transaction_hash'
  has_many :contract_states, primary_key: 'transaction_hash', foreign_key: 'transaction_hash'

  before_validation :downcase_hex_fields
  
  scope :newest_first, -> { order(block_number: :desc, transaction_index: :desc) }
  scope :oldest_first, -> { order(block_number: :asc, transaction_index: :asc) }
  
  scope :unprocessed, -> { where(processing_state: "pending") }
  
  def content
    content_uri[/.*?,(.*)/, 1]
  end
  
  def parsed_content
    JSON.parse(content)
  end
  
  def processed?
    processing_state != "pending"
  end
  
  def self.required_initial_owner
    "0x00000000000000000000000000000000000face7"
  end
  
  
  private
  
  def downcase_hex_fields
    self.transaction_hash = transaction_hash.downcase
    self.creator = creator.downcase
    self.initial_owner = initial_owner.downcase
  end
end
