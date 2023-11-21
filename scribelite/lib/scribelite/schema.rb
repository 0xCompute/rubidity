

module ScribeDb

class CreateDb

def up

ActiveRecord::Schema.define do

create_table :inscribes, :id => :string do |t|    
    ## "id": "0a3a4dbf6630338bc4df8e36bd081f8f7d2dee9441131cb03a18d43eb4882d5ci0",
    ## note: change to uuid (universally unique id) - why? why not?
    ##        id gets used by row_id (internal orm db machinery) and is int
   ## t.string   :uuid,  null: false, index: { unique: true, name: 'inscribe_uuids' }

   ## "title": "Inscription 10371414",
   ##   note: use num/no. from title only - why? why not?
    t.integer  :num, null: false, index: { unique: true, name: 'inscribe_nums' }
   
    ##  "content length": "85 bytes",
    ## note:  extract bytes as integer!!!
    ##    change to bytes - why? why not?
    t.integer  :bytes
    ## "content type": "text/plain;charset=utf-8",
    ## note: make sure always lower/down case!!!
    t.string   :content_type
    
 
    ## add allow duplicate opt-in protocol flag e.g. esip6
    ## t.boolean    :duplicate   -
 
  ## timestamp last
  t.timestamps
end


## change to tx/txs or txn/txns - why? why not?

create_table :calldatas, :id => :string do |t|
    ## "id": "0a3a4dbf6630338bc4df8e36bd081f8f7d2dee9441131cb03a18d43eb4882d5ci0",
    ## note: change to uuid (universally unique id) - why? why not?
    ##        id gets used by row_id (internal orm db machinery) and is int
    ## t.string   :id,  null: false, index: { unique: true, name: 'blob_uuids' }
 
    t.binary     :data   # ,  null: false
    t.string     :sha    # ,  null: false    ## sha hash as hexstring
 
    ## "timestamp": "2023-06-01 05:00:57 UTC"
    ##   or use date_utc ???
    ##   or change to t.integer AND timestamp  or time or epoch(time) - why? why not?
    t.datetime    :date, null: false

    t.integer    :block, null: false
    t.integer    :fee
    t.integer    :value

    ###
    ## "address": "bc1p3h4eecuxjj2g72sq38gyva732866u5w29lhxgeqfe6c0sg8xmagsuau63k",
    ##    is this minter/inscriber addr???
    ##  change to minter?? or such - why? why not?
    ##             creator 
    t.string     :from, null: false

    ## add to address too - why? why not?
    t.string     :to   
  ## timestamp last
  t.timestamps
end

end # block Schema.define

end # method up
end # class CreateDb
  
end # module ScribeDb
