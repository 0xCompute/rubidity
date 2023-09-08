# Rubidity Notes 


##  Changelog

_What's different from "upstream" rubidity in ethscription vm?_


### remove active_support (gem) dependency 

-  requires delegate  - replace with def_delegate ??
-  requires Array#exclude?  - replace with ??
    --   if TYPES.exclude?(type_name)


in class AbiProxy / def initialize
change 
     @data = {}.with_indifferent_access
to
     @data = {}


## many uses of blank? and present?
##   keep activesupport for now - or add blank? (requires many extensions)
##    present? =>  !blank?


