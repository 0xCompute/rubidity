#  Facet Database Schema



## Table name: eth_blocks

```
  id                :bigint           not null, primary key
  block_number      :bigint           not null
  timestamp         :bigint           not null
  blockhash         :string           not null
  parent_blockhash  :string           not null
  imported_at       :datetime         not null
  processing_state  :string           not null
  transaction_count :bigint
  runtime_ms        :integer
  created_at        :datetime         not null
  updated_at        :datetime         not null
```

<details>
<summary markdown="1">Indexes</summary>

```
  index_eth_blocks_on_block_number                      (block_number) UNIQUE
  index_eth_blocks_on_block_number_completed            (block_number) WHERE ((processing_state)::text = 'complete'::text)
  index_eth_blocks_on_block_number_pending              (block_number) WHERE ((processing_state)::text = 'pending'::text)
  index_eth_blocks_on_blockhash                         (blockhash) UNIQUE
  index_eth_blocks_on_imported_at                       (imported_at)
  index_eth_blocks_on_imported_at_and_processing_state  (imported_at,processing_state)
  index_eth_blocks_on_parent_blockhash                  (parent_blockhash) UNIQUE
  index_eth_blocks_on_processing_state                  (processing_state)
  index_eth_blocks_on_timestamp                         (timestamp)
```

</details>


## Table name: ethscriptions

```
  id                :bigint           not null, primary key
  transaction_hash  :string           not null
  block_number      :bigint           not null
  block_blockhash   :string           not null
  transaction_index :bigint           not null
  creator           :string           not null
  initial_owner     :string           not null
  block_timestamp   :bigint           not null
  content_uri       :text             not null
  mimetype          :string           not null
  processed_at      :datetime
  processing_state  :string           not null
  processing_error  :string
  gas_price         :bigint
  gas_used          :bigint
  transaction_fee   :bigint
  created_at        :datetime         not null
  updated_at        :datetime         not null
```

<details>
<summary markdown="1">Indexes & Foreign Keys</summary>

```
  index_ethscriptions_on_block_number_and_transaction_index  (block_number,transaction_index) UNIQUE
  index_ethscriptions_on_processing_state                    (processing_state)
  index_ethscriptions_on_transaction_hash                    (transaction_hash) UNIQUE

 Foreign Keys

  fk_rails_...  (block_number => eth_blocks.block_number) ON DELETE => cascade
```

</details>


## Table name: transaction_receipts

```
  id                         :bigint           not null, primary key
  transaction_hash           :string           not null
  from_address               :string           not null
  status                     :string           not null
  function                   :string
  args                       :jsonb            not null
  logs                       :jsonb            not null
  block_timestamp            :bigint           not null
  error                      :jsonb
  to_contract_address        :string
  effective_contract_address :string
  created_contract_address   :string
  block_number               :bigint           not null
  transaction_index          :bigint           not null
  block_blockhash            :string           not null
  return_value               :jsonb
  runtime_ms                 :integer          not null
  call_type                  :string           not null
  gas_price                  :bigint
  gas_used                   :bigint
  transaction_fee            :bigint
  created_at                 :datetime         not null
  updated_at                 :datetime         not null
```

<details>
<summary markdown="1">Indexes  & Foreign Keys</summary>

```
  index_contract_tx_receipts_on_block_number_and_tx_index    (block_number,transaction_index) UNIQUE
  index_transaction_receipts_on_block_number                 (block_number)
  index_transaction_receipts_on_block_number_and_runtime_ms  (block_number,runtime_ms)
  index_transaction_receipts_on_created_contract_address     (created_contract_address)
  index_transaction_receipts_on_effective_contract_address   (effective_contract_address)
  index_transaction_receipts_on_runtime_ms                   (runtime_ms)
  index_transaction_receipts_on_to_contract_address          (to_contract_address)
  index_transaction_receipts_on_transaction_hash             (transaction_hash) UNIQUE

 Foreign Keys

  fk_rails_...  (block_number => eth_blocks.block_number) ON DELETE => cascade
  fk_rails_...  (transaction_hash => ethscriptions.transaction_hash) ON DELETE => cascade
```

</details>


## Table name: contract_artifacts

```
  id                         :bigint           not null, primary key
  transaction_hash           :string           not null
  internal_transaction_index :bigint           not null
  block_number               :bigint           not null
  transaction_index          :bigint           not null
  name                       :string           not null
  source_code                :text             not null
  init_code_hash             :string           not null
  references                 :jsonb            not null
  pragma_language            :string           not null
  pragma_version             :string           not null
  created_at                 :datetime         not null
  updated_at                 :datetime         not null
```

<details>
<summary markdown="1">Indexes & Foreign Keys</summary>

```
  idx_on_block_number_transaction_index_internal_tran_570359f80e  (block_number,transaction_index,internal_transaction_index) UNIQUE
  idx_on_transaction_hash_internal_transaction_index_c95378cab3   (transaction_hash,internal_transaction_index) UNIQUE
  index_contract_artifacts_on_init_code_hash                      (init_code_hash) UNIQUE
  index_contract_artifacts_on_name                                (name)

 Foreign Keys

  fk_rails_...  (block_number => eth_blocks.block_number) ON DELETE => cascade
  fk_rails_...  (transaction_hash => ethscriptions.transaction_hash) ON DELETE => cascade
```

</details>


## Table name: contracts

```
  id                     :bigint           not null, primary key
  transaction_hash       :string           not null
  block_number           :bigint           not null
  transaction_index      :bigint           not null
  current_type           :string
  current_init_code_hash :string
  current_state          :jsonb            not null
  address                :string           not null
  deployed_successfully  :boolean          not null
  created_at             :datetime         not null
  updated_at             :datetime         not null
```

<details>
<summary markdown="1">Indexes & Foreign Keys</summary>

```
  idx_on_address_deployed_successfully                  (address) UNIQUE WHERE (deployed_successfully = true)
  index_contracts_on_address                            (address) UNIQUE
  index_contracts_on_current_init_code_hash             (current_init_code_hash)
  index_contracts_on_current_state                      (current_state) USING gin
  index_contracts_on_current_type                       (current_type)
  index_contracts_on_deployed_successfully              (deployed_successfully)
  index_contracts_on_deployed_successfully_and_address  (deployed_successfully,address) UNIQUE
  index_contracts_on_transaction_hash                   (transaction_hash)

 Foreign Keys

  fk_rails_...  (block_number => eth_blocks.block_number) ON DELETE => cascade
  fk_rails_...  (transaction_hash => ethscriptions.transaction_hash) ON DELETE => cascade
```

</details>


## Table name: contract_calls

```
  id                         :bigint           not null, primary key
  transaction_hash           :string           not null
  internal_transaction_index :bigint           not null
  from_address               :string           not null
  to_contract_address        :string
  created_contract_address   :string
  effective_contract_address :string
  function                   :string
  args                       :jsonb            not null
  call_type                  :string           not null
  return_value               :jsonb
  logs                       :jsonb            not null
  error                      :jsonb
  status                     :string           not null
  block_number               :bigint           not null
  block_timestamp            :bigint           not null
  block_blockhash            :string           not null
  transaction_index          :bigint           not null
  start_time                 :datetime         not null
  end_time                   :datetime         not null
  runtime_ms                 :integer          not null
  created_at                 :datetime         not null
  updated_at                 :datetime         not null
```

<details>
<summary markdown="1">Indexes & Foreign Keys</summary>

```
  idx_on_block_number_txi_internal_txi                (block_number,transaction_index,internal_transaction_index) UNIQUE
  idx_on_tx_hash_internal_txi                         (transaction_hash,internal_transaction_index) UNIQUE
  index_contract_calls_on_call_type                   (call_type)
  index_contract_calls_on_created_contract_address    (created_contract_address) UNIQUE
  index_contract_calls_on_effective_contract_address  (effective_contract_address)
  index_contract_calls_on_from_address                (from_address)
  index_contract_calls_on_internal_transaction_index  (internal_transaction_index)
  index_contract_calls_on_status                      (status)
  index_contract_calls_on_to_contract_address         (to_contract_address)

 Foreign Keys

  fk_rails_...  (block_number => eth_blocks.block_number) ON DELETE => cascade
  fk_rails_...  (transaction_hash => ethscriptions.transaction_hash) ON DELETE => cascade
```

</details>


## Table name: contract_states

```
  id                :bigint           not null, primary key
  transaction_hash  :string           not null
  type              :string           not null
  init_code_hash    :string           not null
  state             :jsonb            not null
  block_number      :bigint           not null
  transaction_index :bigint           not null
  contract_address  :string           not null
  created_at        :datetime         not null
  updated_at        :datetime         not null
```

<details>
<summary markdown="1">Indexes & Foreign Keys</summary>

```
  index_contract_states_on_addr_block_number_tx_index             (contract_address,block_number,transaction_index) UNIQUE
  index_contract_states_on_contract_address                       (contract_address)
  index_contract_states_on_contract_address_and_transaction_hash  (contract_address,transaction_hash) UNIQUE
  index_contract_states_on_state                                  (state) USING gin
  index_contract_states_on_transaction_hash                       (transaction_hash)

 Foreign Keys

  fk_rails_...  (block_number => eth_blocks.block_number) ON DELETE => cascade
  fk_rails_...  (contract_address => contracts.address) ON DELETE => cascade
  fk_rails_...  (transaction_hash => ethscriptions.transaction_hash) ON DELETE => cascade
```

</details>


## Table name: contract_transactions

```
  id                :bigint           not null, primary key
  transaction_hash  :string           not null
  block_blockhash   :string           not null
  block_timestamp   :bigint           not null
  block_number      :bigint           not null
  transaction_index :bigint           not null
  created_at        :datetime         not null
  updated_at        :datetime         not null
```

<details>
<summary markdown="1">Indexes & Foreign Keys</summary>

```
  index_contract_transactions_on_transaction_hash  (transaction_hash) UNIQUE
  index_contract_txs_on_block_number_and_tx_index  (block_number,transaction_index) UNIQUE

 Foreign Keys

  fk_rails_...  (block_number => eth_blocks.block_number) ON DELETE => cascade
  fk_rails_...  (transaction_hash => ethscriptions.transaction_hash) ON DELETE => cascade
```

</details>


## Table name: system_config_versions

```
  id                  :bigint           not null, primary key
  transaction_hash    :string           not null
  block_number        :bigint           not null
  transaction_index   :bigint           not null
  supported_contracts :jsonb            not null
  start_block_number  :bigint
  admin_address       :string
  created_at          :datetime         not null
  updated_at          :datetime         not null
```

<details>
<summary markdown="1">Indexes & Foreign Keys</summary>

```
  idx_on_block_number_transaction_index_efc8dd9c1d  (block_number,transaction_index) UNIQUE
  index_system_config_versions_on_transaction_hash  (transaction_hash) UNIQUE

 Foreign Keys

  fk_rails_...  (block_number => eth_blocks.block_number) ON DELETE => cascade
  fk_rails_...  (transaction_hash => ethscriptions.transaction_hash) ON DELETE => cascade
```

</details>




