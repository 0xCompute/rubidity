
## note - rquires activesupport
##  e.g. delegate - more??
#        Array#exclude?


require 'active_support/all'
## require 'active_support/core_ext/module/delegation'


require_relative 'contract_errors'

require_relative 'type'
require_relative 'typed_variable'
require_relative 'array_type'
require_relative 'mapping_type'

require_relative 'state_variable'
require_relative 'state_proxy'

require_relative 'contract_implementation'
require_relative 'abi_proxy'
require_relative 'function_context'

require_relative 'contract_transaction_globals'
