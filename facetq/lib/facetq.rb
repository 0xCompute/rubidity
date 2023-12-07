
require 'active_record'  


## todo/fix - add dummy application record if not defined
##   make it work later
## class ApplicationRecord < ActiveRecord::Base 
## end  

require_relative 'facetq/json_sorter'


require_relative 'facetq/models/eth_block'
require_relative 'facetq/models/ethscription'
require_relative 'facetq/models/transaction_receipt'
require_relative 'facetq/models/contract'
require_relative 'facetq/models/contract_call'
require_relative 'facetq/models/contract_state'
require_relative 'facetq/models/contract_transaction'
require_relative 'facetq/models/contract_artifact'
require_relative 'facetq/models/system_config_version'



