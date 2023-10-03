# Rubidity By Example

an introduction to Rubidity with simple examples (inspired and mostly following [Solidity By Example](https://solidity-by-example.org))




NOTE:  While Rubidity has / uses 100%-compabible Solidity 
data types and (application binary interfaces) abis and method sig(natures) and call data - Rubidity syntax (and semantics) sometimes differs following the Ruby philosophy of programmer productivity and fun.


"Less is more"  highlights include:

No internal/private/public "trilogy" for state (storage variables).
Only internal and public AND "auto-magically" depending on naming convention.  Internals MUST start with underscore (_) otherwise state 
(storage) variables are public.

No internal/private/public/external "tetralogy or quadrology" for functions.
Only internal and public AND "auto-magically" depending on naming 
convention.

No multiple "diamon-shaped whatever-algo linearized" inheritance.  Only
linear single inheritance.  
Use module includes for adding (reusing/shared) functions.

No modifiers. Use functions or if clauses.

No immutable state (storage) variables. [Maybe add back a "freeze" option later?]

No constant state (storage) variables. Use "plain" constants.


To be continued...   the idea or the theme is "less is more" or better security by making "obfuscated" code harder and so on.




## Basics

[Hello World](hello-world)




