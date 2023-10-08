

def _merge_events( parents )
    parent_events = parents.map(&:events).reverse
    contract_class.events = parent_events.reduce( {} ) { |mem,h| mem.merge(h) }
                                         .merge(contract_class.events)
end
