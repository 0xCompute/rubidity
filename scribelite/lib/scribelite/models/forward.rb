
### forward references
##   require first to resolve circular references

module ScribeDb
module Model

#############
# ConfDb
Prop      = ConfDb::Model::Prop


class Inscribe    < ActiveRecord::Base ; end
class Calldata    < ActiveRecord::Base ; end


end # module Model

# note: convenience alias for Model
# lets you use include ScribeDb::Models
Models = Model   
end # module ScribeDb


