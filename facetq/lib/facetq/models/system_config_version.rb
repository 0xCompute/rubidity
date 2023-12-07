# == Schema Information
#
# Table name: system_config_versions
#
#  id                  :bigint           not null, primary key
#  transaction_hash    :string           not null
#  block_number        :bigint           not null
#  transaction_index   :bigint           not null
#  supported_contracts :jsonb            not null
#  start_block_number  :bigint
#  admin_address       :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  idx_on_block_number_transaction_index_efc8dd9c1d  (block_number,transaction_index) UNIQUE
#  index_system_config_versions_on_transaction_hash  (transaction_hash) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (block_number => eth_blocks.block_number) ON DELETE => cascade
#  fk_rails_...  (transaction_hash => ethscriptions.transaction_hash) ON DELETE => cascade
#
class SystemConfigVersion < ActiveRecord::Base   # ApplicationRecord
  
  belongs_to :ethscription,
  primary_key: 'transaction_hash', foreign_key: 'transaction_hash', optional: true
  
  scope :newest_first, -> {
    order(block_number: :desc, transaction_index: :desc) 
  }
  
  def self.latest_tx_hash
    newest_first.limit(1).pluck(:transaction_hash).first
  end
  
  def self.system_mimetype
    "application/vnd.facet.system+json"
  end
  
  
  def operation_data
    JSON.parse(ethscription.content).fetch('data')
  rescue JSON::ParserError => e
    raise "JSON parse error: #{e.message}"
  end
  

  def self.current
    (newest_first.first || new).freeze
  end
  
=begin  
  def as_json(options = {})
    super(
      options.merge(
        only: [
          :supported_contracts,
          :block_number,
          :transaction_index,
        ]
      )
    )
  end
=end 

  def self.current_admin_address
    current.admin_address || ENV.fetch("INITIAL_SYSTEM_CONFIG_ADMIN_ADDRESS").downcase
  end
end
