# Changelong  - Good Morning (gm)

copy pasted from the #vm-dumb-contracts channel in the ethscriptions discord for reference - reverse order (latest first)



gm.

while working on the (boring) typed gem / library looks like running in circles  (who cares? it's all about the ui, isn't it?) i think having a great (or is that solid?) foundation helps.  today i  removed the `Typed<Type>` prefix to make the (rubidity) typed classes look more "natural" if used "stand-alone" e.g. `TypedString` becomes `String`, `TypedMapping` becomes `Mapping`, `TypedEnum` becomes `Enum`, `TypedStruct` becomes `Struct` etc.   ps: anyways, always  happy to try out / convert contracts in solidity to rubidity. anyone?  next on my sample list is the "classic" Liquid / Delegative Democracy Contract - Let's Vote (or Delegate Your Vote) on a Proposal. see -> https://github.com/s6ruby/redpaper#liquid--delegative-democracy---lets-vote-or-delegate-your-vote-on-a-proposa


gm. 

thanks for taking the time and for the update on rubidity.  and 100% that rubidity has its own rules. i personally would use / recommend a solidity subset (but of course trying to stay compatible unless there's a good reason not to) for the data types (uint, address, etc) and public abis only.  yeah - the rubidity syntax. ha.  no more class. and import (not require).  as you know if i dare to say i'd say what matters is semantics not syntax (and thus, i still can see that both styles - "classic" and "more ruby-ish" end up with the same results).  i am   more than happy if there's any interest in proposing (or better showing by example) a "language-independent" test format (& scrip)  for (rubidity) contract execution and (storage) states (in json & yaml) and such for (re)use.  but sure it might be redundant because (test or soon production) dumb contracts and states are the (best) reference or such. 
 ps: to sum-up the rubidity "more ruby-ish" updates - i got structs & enums added (and working) and arrays and mappings now use class builders too (e.g. `TypedArrayString`, `TypedArrayUInt`, etc) making it i think faster and more robust because the mapping is one-to-one (1:1) and the idea with the "more ruby-ish" style is too cut / remove all proxys & layers and stay to the "metal" as close a possible resulting in more robust and easy to debug and follow code.    anyways, sorry for thinking out loud.    have a great weekend and keep up the great work (and looking forward to the rubidity extraction). 


one more ("more ruby-ish") rubidity update for today.  i reworked the core (solidity/rubidity) data types available with "zero-dependency" in a stand-alone gem called rubidity-typed for easy (re)use - see https://www.rubydoc.info/gems/rubidity-typed/0.7.1  - that incl. now structs & enums and no more symbols (e.g. `:uint`, `:string`, `:array`, `:mapping`, etc.) anywhere.  all typed classes have a "metatype" singelton  (kind of like the ruby .class but using .type) and follow the zero mechanics (and incl. `zero`, `zero?` and most import `new_zero` and so on).  i will add more tests next week. no matter the rubidity syntax - "classic" or "more ruby-ish"?   - under the hood if i dare to say using typed classes (with a one-to-one - 1:1 mapping)  make for a robust foundation if anyone is interested. serve yourself.


gm.

today i am trying to complete the data types by adding ... yes, enums. why not? here we go. a first version of (user-defined) enums in rubidity contracts working. see the solidity test enum (docu) example in rubidity here -> https://github.com/s6ruby/rubidity/blob/master/contracts/testenum.rb   or a more low-level TypedEnum test script here -> https://github.com/s6ruby/rubidity/blob/master/rubidity-typed/sandbox/enums.rb   questions? comments? more than welcome. 


gm.

another little update on rubidity.  the struct machinery is working incl. for mappings. see the Satoshi Dice contract sample here -> https://github.com/s6ruby/rubidity/blob/master/contracts/satoshidice.rb and the (simulacrum) test here ->  https://github.com/s6ruby/rubidity/blob/master/contracts/sandbox/satoshidice.rb  that's it for today. 


gm.

not sure if anyone else cares about rubidity here (making great progress but yeah always deluding and talking to myself ;-). anyways, i try to add structs today to the (alternate "more-rubish") rubididy (lang runtime). if anyone has a good example for structs to use in contracts, please tell. to test i will start with the oldie / classic e.g. Win x65 000 - Roll the (Satoshi) Dice here -> https://github.com/s6ruby/redpaper#win-x65-000---roll-the-satoshi-dice    

> planning to write a number of dumb contracts in the coming weeks

welcome.  great to have you here. i assume middlemarch is super busy, 
thus,  happy to help along. i think the best way to start is with the solidity contract code if you have any. if you post a copy i can try to run on the (more ruby-ish) rubidity (great for testing and easy to get started if you got ruby up and running). 

anyways, to conclude for today (yes, i am not 10x or such - progress but slowly) the (rubidity) struct machinery works - see https://github.com/s6ruby/rubidity/blob/master/rubidity-typed/sandbox/struct.rb for some (basic) use / tests and the machinery here  - https://github.com/s6ruby/rubidity/blob/master/rubidity-typed/lib/rubidity/typed/typed_struct_builder.rb  and here - https://github.com/s6ruby/rubidity/blob/master/rubidity-typed/lib/rubidity/typed/typed_struct.rb    the "hard" (or missing) part really is to plug-in structs into arrays and mappings too (and all the way down, that is, recursive).  that's a task for tomorrow.


gm.

> I will think about this ABI thing.
> I think we are doing something pretty
> close but we don't have events AND we don't have structs 
> AND structs don't even exist yet! How should we do structs?
>
> My next project is going to be extracting Rubidity 
> from the run time context of the VM

for today let me state the the obvious [offer].  i am happy to add structs (and enums) in the next day(s) and add support of interfaces (and interface ids) via 100%-compatible solidity method ids and such.  if you extract the rubidity language script code with a well-defined runtime api / interface than you can in theory or practice replace it with the (modular) rubidity gem.  anyways, all code is public domain at a minimum you are welcome to copy-n-paste (and change) whatever you think makes sense. keep it up.

something different. one more rubidity ("more ruby-ish" syntax / style) update:  i finally switched over all type symbols (e.g. `:uint`, `:string`, `:address`, etc.) to true typed classes e.g. `UInt`, `String`, `Address`, etc. see a contract example here -> https://github.com/s6ruby/rubidity/blob/master/rubidity/sandbox/testtoken.rb    one bonus is "free" type (class) checking by ruby itself. anyways, as always sorry for taking up your time. keep up your great work. 



gm.

congrats to the dumbswap app launch.   about the file extension i am for .rb (it's just ruby) but as you know by now i am the more ruby-ish the better kind of guy.
looking forward to seeing your own rubidity extracted.   maybe add a /rubidity directory inside the vm repo and reference from rails via relative path (or in gemfile).  anyways, thinking out loud. do what you think is best. 

> structs don't even exist yet! How should we do structs?

structs should't really be hard / difficult. it's bascially a (new/custom) ruby struct class builder / generator.   i have an old version (for universum) here ->  https://github.com/s6ruby/universum/tree/master/safestruct      ps: the missing enums are even easier (than structs) ;-) only uints but structs in theory can get nested incl. having mappings or arrays as fields. 

ps:  i guess pushing out new rubidity gems also pushes up the download count (via bot downloads e.g. rdoc, etc.).   celebrating 1000+ downloads, see -> https://rubygems.org/gems/rubidity    but still waiting for the first user to say hello ;-). 

pps:  note - not trying to squat the rubidity gem name. if you want to have / claim it. happy to hand over and find a different name for the series i am doing if you think i am confusing anyone out there. Otherwise, yes the idea is to stay compatible with your "classic" rubidity (and of course solidity data types & abis). 


gm.

to follow-up from yesterday e.g.  i try to add the public abi solidity json export next.  here we go. i added a first (alpha) version of  the new `AbiProxy#public_abi_to_json` method.  using your standard / built-in contracts find the exported solidity abi json here -> https://github.com/s6ruby/rubidity/tree/master/rubidity-contracts/abi2sol  plus  abi2sol generated interfaces in the readme. as always it is (very) early. anyways,  no wrorries. all the best with the dumbswap launch.  keep it up.  i try to learn and follow / sync-up with the latest updates. 


gm.

today something different. some years ago i put together an ethereum simulator called universum (yes, in ruby).   now that rubidity is a kind of better (or 100% solidity-compatible) version of secure ruby - i put together a 2nd generation ethereum simulator (universum v2)  called ... drum roll, please ....     simulacrum.    i published the first rubidity-simulacrum gem (v0.1) - see  https://github.com/s6ruby/rubidity/tree/master/rubidity-simulacrum   for more.   anyways,   i try to add the public abi solidity json export next.




gm.

about the (rubidity) vm (web) api format i would use / propose following the ethereum lead / model / example and (re)use  JSON-RPC. super-simple and bonus the solidity (ethereum) abi AND the rubidity (esc) abi will be the same / compatible.   the real-world (ethereum) production JSON-RPC looks like ("under-the-hood"):

``` json
{"jsonrpc":"2.0",
 "method":"eth_call",
 "params":[
    {"to":"0x23581767a106ae21c074b2276d25e5c3e136a68b",
     "data":"0xc87b56dd0000000000000000000000000000000000000000000000000000000000000000"},
    "latest"],
  "id":1
}
```

see https://github.com/rubycocos/blockchain/tree/master/ethlite  for my ethlite api client (wrapper) with more  examples.   maybe i am missing something. i assume this is not for the insription itself (but talking to the vm api server).  for the inscription itself to save bytes it might be good to offer choice of formats.

sorry to ask:

> Then again it has the name collision issue..

what is the name collision issue - if you might clarify or have an example?

and if i may add:

> about the ABI; maybe we SHOULD go with the original format.

my understanding is YES definitely use the 100% compatible Solidity JSON ABI  (and from the JSON ABI you can generate "pseudo" solidity - public interfaces with events). i try to add the machinery in the next days in the gem version (to see / try that in practice with all your sample / standard contracts). 

i actually already built a gem to translate json abis into solidity "pseudo" interface code (if i remember) e.g. abi2sol gem - that i can try to "retarget" / reuse, see  https://github.com/rubycocos/blockchain/tree/master/abi2sol 


not trying to sell you on my  ethereum gems ;-)  (free, open source) - but if i dare to say since you already use eth call data than maybe it makes sense to also use abi encoded data in the json-rpc (like ethereum itself).  abi encode / decode is actually not that difficult (even v2 with "nested" arrays & tuples or such). see the abicoder gem here (supporting v2) -> https://github.com/rubycocos/blockchain/tree/master/abicoder 

anyways, a little update on the more ruby-ish rubidity gems - i managed to convert (and run) your contract_implentation.rb tests (specs) - see here https://github.com/s6ruby/rubidity/blob/master/test/contract_implementation.rb  ("ruby-ish" contracts) and here https://github.com/s6ruby/rubidity/blob/master/test/test_contract_implementation.rb (minitests)    (what's missing is the receipt generation and such - but the contract construct / cast / look-up all work).    again sorry if that's too much detail.   that's it for today. keep up the great work. love it all.

ps: sorry i was getting ahead of myself (the abi encoding and json-rpc compatibility looks like overkill) - rethinking the json format for the vm (web) api maybe your format that you use for the inscription might be better and easier - with the big bonus that the inscription and the vm json api format are one and the same. in a v2 you might add more options.



gm.

here's an idea to get others interested in the "discussion" or evolution in rubidity i will open-up some issues / tickets on your repo and also move the comments above (edited somewhat) to your opened ticket / issue.    can it really be that in the whole ruby universe we are the only ones interested in blockchain programming. let's find out. i guess nobody cares but at least there's a "public record" online. 

something different (and a v2 rubidity proposal) i found this write-up / proposal  -> https://inscriptions.gitbook.io/docs/tokens-insk-1    the solidity samples use interfaces and interface ids / method ids. i am too a big fan of method ids and it's actually not hard to do it in ruby itself. i started here see -> https://github.com/rubycocos/blockchain/blob/master/abiparser/sandbox/calc_interfaces.rb      thus, the idea in v2 is to adopt / use "classic" or standard solidity interface and method ids.  on a more practial note i try to add the solidity json abi export today to rubidity contracts.


gm.


about the contract (source) as data (frozen with hash) i think that's a great idea for security.  about moving away from ruby. no worries about the more or less ruby-ish style.  i try to support (and bring back) the "classic" style  so i can run your "frozen" contracts maybe without change with the rubidity gem version.     about the proposed upgrade manager for now i am not really sure i understand.  i am might oversimplify. if you upgrade i would NOT do it on-the-fly but  change / fix / upgrade the contract (source) and than RESTART the server (client), thus, only one version possible but i see maybe for different block heights you need different versions.  again sorry i am still learning and catching-up and thus,  can't really comment what's the best / easiest way forward  - but sure 100% with you keeping the contract sources "indepedent / stand-alone / isolated" so you can run in different "context" or in a "sandbox", that's actually what i am trying to do with the modular version from day one ;-) kind of way.  keep going. i try to follow and catch-up.

if i may add: 

> Currently we get a contract's implementation logic like this:
>
> ... `"Contracts::#{self.type}".constantize.new(self)`

in the modular rubidity gem version i removed constantize  and all contract types are always "eager-loaded" ruby classes (not symbols or strings).   for sure i am with you removing the "default" `Contracts::` namespace - i removed `Contracts::` from day one ;-) - the idea is use whatever (not something "dictated" by rails zeitwerk auto-loading convention or such).  and again 100% with you keeping the contract source in a (frozen) string and  loading (the source string/text) via database or whatever (for security and deterministic reproducability or such). 

don't get me wrong. the idea of the rubidity gem is to work "off-rails", thus, i had really no choice but first to remove activesupport   BUT yeah rails is great and amazing - not anti-zeitwork or using naming conventions for automagic lookup.   i try to start on the (sql) database support (activerecord) next week. yet another rubidity gem upcoming! (plus trying to "downgrade" to add sqlite support).    and again i am 100% with you keeping the contract source in a (frozen) string and  loading (the source string/text) via database or whatever.  and also love the idea of (built-in) support for upgradable (or versioned) contracts  (with "in-place" code replacement and "automagically" (re)using the contract storage / state by (re)using the same contract address or such). keep up the great work. trying to follow and catch-up. have a great weekend and sorry for taking up your time. 


gm.

i reworked the docu / usage samples for the rubidity-typed gem (the "zero-dependency" foundation with the value and reference type classes - with the idea of 100%-compatibility to solidity types & abis), see -> https://github.com/s6ruby/rubidity/tree/master/rubidity-typed#usage   it is still (very) early. the big idea is by having "dedicated" type classes to make the "machinery" easier to understand (and use) and more robust (no proxies, no method_missing magic, etc.)


gm.

i agree 100% that yes, solidity is the protocol is a great principle and that i oversimplify and yes it will be case by case (that is, contract by contract) and than you have to have test sets for the contracts. thus, not really being a free for all but only support for tested contracts with rubidty and solidity reference code or such.  
   
now that i have a kind of basic version i am starting with adding support for contracts calling contracts or such - trying the Uniswap contracts and the tests here -> https://github.com/ethscriptions-protocol/ethscriptions-vm-server/blob/main/spec/models/contract_implementation_spec.rb     and yes, i am kind in the happy / easy situation that i can experiment with the "basics" because no test (live) installation.  if it all works out to have modular (minimal) rubidity gems  in the end i can't promise but so far looking good. thank you for your support and keep going.  love the (real-world) contract-driven style and great to use Uniswap.  

ps:  about json parsing - kind of insane that solidity (or ethereum really) doesn't (in 2023!) have a built-in standard library.  i think this is another big win for rubidity / ethscriptions vm.  kind of the best of zeppelin contracts and solday and such - not really fully up-to-date on the solidity contract programming edge / state-of-the art so i might be missing something.  

pps: 

>  On the `@` thing I guess you'd still have the problem with
>   `@a = TypedUint256.new( 10 )`
>   `@a = 5 - @a` 

i think this might be possible to handle "automagically" with implicit type (conversion) methods (a la to_int, to_str, to_ary, to_hash, etc.) and using a to_uint monkey patch or such on Integer (but not 100% sure i have to look this up - but it's for sure a "well-known" ruby (custom/own) type limitation / quirk with known workarounds that may or may not work in this case - sorry i don't know yet).

ppps:
> Who knows though long term maybe there IS a way to enforce this if
> some AI can rebuild a gas-aware Ruby runtime!

for sure creating a (mini) typed ruby that offers the best of all worlds should be possible - mruby might be a start here ->  https://mruby.org/  but that would be a (dedicated) project for some months i'd say.   another quicker option maybe almost usable "out-of-the-box" might be crystal (strongly typed ruby by definition) here -> https://crystal-lang.org/ 



gm.

about:

> if a function signature says the function has no return value 
> (ie is nil I guess in our world), do we enforce this? 

if i dare to say the "security" through type-checking is an illusion - that is to say if you want a real safe / secure language than you have to make it functional and strongly typed and static compiled with strongly-typed virtual machine (vm) and all the way down.   the point?  it's an illusion. if i dare to say i am with your write-up in [ESIP-4: The Ethscriptions Virtual Machine](https://docs.ethscriptions.com/esips/esip-4-the-ethscriptions-virtual-machine) where you say / write  solidity is the protocol - that is - in the end what matters is that if you have two or three or four different runtimes (rubidity classic, rubidity "more ruby-ish", ...) that they result in the same state (how you end-up there - who cares?)

ps: while thinking some more - since every public function gets a wrapper - here's a (practical) idea - in the wrapper if the function returns nothing than "auto-magically" generate / add to return nothing (that is, nil).   if accidentialy something gets returned in the "unsafe" method that simply gets ignored and all public functions in rubidity (that is, all typed / safe auto-generated wrapper methods) always guarantee to return nil if they specify to return nothing in the abi declaration / signature.

anyways, the design philosophy i (try to) follow is always - keep it simple (and beautiful). less is more.  thus, i personally don't see the need to add return nil when you can auto-generate in the (type-safe) wrapper (method) anyways.   pps: sorry - thinking out loud and going on forever.   in the end it doesn't matter - one more quirk who cares. don't worry too much. both styles work.

about upgrades -   great to use a real-world example like Uniswap V1 and V2.    i'd say a major win for ethscriptions vm is that the state is separate from the contract. if you replace (update-in-place) the contract code than you can (re)use the state. win-win!     and yes, if the public interface changes radically or the state / storage structure than a new version might be better.       using a name service / registry for contracts might be another idea to have stable contract service point. again sorry for thinking out loud and i am not claiming to have all the answers. i am still trying to catch-up and learn.   ps:  fyi:  i try to learn more about Uniswap today syncing-up "upstream" with the uniswap contracts in the ethscriptions-vm-server.


one more comment about:

>  you can't just check types at the end because 
> of `@a = 10; @a -= 20; @a += 20`

i tried now and only the first `@a = 10`  is assigned an unchecked value. the other two cases actually work (get "automagically" type checked) because `@a = @a - 20` and the typed variable is the left side of the operator.  i double checkd in code e.g.

``` ruby
a = TypedUint256.new( 10 )
a += 20
pp a
#=> <val uint256:30>
```

Still the typed var.  and sure (no magic here):

``` ruby
a = 10
pp a
#=> 10
```

again sorry if that is too much detail. now i try to update the types adding bytes, bytes32, and such to sync-up. love the address "unification". 



gm.


i pushed out a new rubidity gem v0.3 that now works without `FunctionContext`, `FunctionProxy`, etc. it's all "plain" ruby with (auto-generated) typed method wrappers and public getters and such and, thus, the "under-the-hood" machinery basicially super-simple.

about 1) 

> One issue with the instance variable thing is 
> that you can't just check types at the end 
> because of `@a = 10; @a -= 20; @a += 20`. 
> At the end this turns out okay, but (assuming `@a` is a uint)
>  it should b low up on the intermediate step

i'd say the recommendation here is that `@a -= 20; @a += 20`  is a bad practice and can be catched via a (static) type checker / linter ;-).      in the meantime you can use `@a -= uint(20); @a += uint(20)`  and you WILL get the error / exception.

thinking about it again  i think `@a = @a + 10` or `@a = @a - 10` that will get typed checked because the typed var is on the left side of the operator.   maybe `+=` or `-=` is different?  if not, it will get typed checked at runtime.   anyways, i will  add tests with the next update. 

and, yes, in the end - everytime you serialize the state all ivars WILL get type-checked again (but yeah no guarantee what happend inbetween) for that you would need a static compiled language anyways, really.
if i may comment on upgradeable contracts ... 
if i dare to say i would simply replace the contract. 
no proxies and other delegate bullshit.
replace the code! the state is in the database or storage.
sorry if i oversimplify or about thinking out loud.  anyways, i see it like ethereum clients that get upgraded by "simply" replacing because the code is "off-chain".  same with ("built-in / standard) dumb contracts. if you want to inscribe the ruby code than you can still use a registry and change / replace the inscription id for the contract in your vm / indexer. that's it. no proxy. no delegate.
anyways, love it. keep going i try to catch-up and follow (and sync-up tomorrow the vm code and built-in contracts). 


gm.

another little update. all (sample) rubidity contracts (ERC20, ERC721, ...) now work with the new style (types still using symbols) but otherwise getting closer to ruby. see -> https://github.com/s6ruby/rubidity/tree/master/rubidity-contracts/lib/rubidity/contracts
ps:  one benefit is better rdocs (not perfect but not completely useless either). see -> https://www.rubydoc.info/gems/rubidity-contracts/0.2.2/PublicMintERC20


gm.

about 1)   about symbols vs type classes. it shouldn't be too hard to allow both styles -  i am currently still using symbols (but "under-the-hood" it is all typed classes).

about 2)   i was worried too - but the reality is that all methods must be typed and thus will have typed parameters and write access to arrays or maps is usually using [] that gets overloaded / handled by `TypedArray`/`Map<>`.    in the worst case when you assign a "plain" string or integer literal than not all is lost because the serialize can (and will) check the (storage/state) instance var types.  if they do not match, the strict option is to report a `TypeError` and the "flex" option is to try to type cast the literal before calling serialize.  thus, in practice it works like a charm with the added bonus that instance variables ARE private by definition and can only get accessed via public (typed) setters or getters. but sure i might be too optimistic and, thus, the idea is to try out (and test)  more contracts.

about 3)  sig vs functions - happy to add support for both (but of course with the ruby-ish semantics "under-the-hood").

> about "what are we doing here" because my version is currently 
> quite optimized to enable correct line-by-line Solidity ports, 
> whereas a broader goal might be to just forget about Solidity 
> and think "Okay if we have this stream of events from somewhere, 
> who cares where, how can we build an app platform"

sorry for any misunderstanding.   i am still 100% with you on being 100% solidity port.    the semantics is still 100% solidity (using the public abi and solditity types)  only the syntax is more ruby-ish (with the idea that "under-the-hood" the code will be much simpler).
love your idea of having the public_abi on contracts.
over at the ruby code commons (cocos) i wrote a couple of ethereum abi gems  abicoder, abiparser, abigen, abidoc, etc see -> https://github.com/rubycocos/blockchain/tree/master  and  while maybe not working out-of-the "gem / box"  right now. the idea is  to add a to_abi_json or to_soldity to contracts that writes out the abi json (100% compatible) or the abi json in a human solidity "pseudo" interface code.   anyways, all i am trying to say that your idea / goal of 100% solidity compatible  is the winner because solidity is the king in blockchain land and should make it easy / easier to interoperate. 
but yeah sure - one radical idea / option would be to just use ruby and don't care about solidity types and serialize (dump) and deserialize ( load) the contract state to json (that is, the world's most popular data exchange standard in the world).  but since you are building on ethereum i think it might be too radical and, thus, i would keep  the state / storage and public abis 100% solidity-compatible to interoperate as you try / do now. 

if that makes any sense i see rubidity like a kind of ruby version of pythonic vyper - see https://docs.vyperlang.org/  with the BIG difference that this is of course a revolution. Meaning the storage is "off-chain" and the indexer runs the contract and only cares about load / dump (deserialize / serialize) and doesn't need to run on the ethereum vm (evm). rubidity runs on ruby. other (future) indexer can use whatever.  anyways, sorry if that's too much detail / thinking out loud.   please, keep going. love the dumb contract revolution and rubidity classic (or more ruby-ish).


gm.

little update. the SimpleToken contract now works with the new style (types still using symbols) but otherwise getting closer to ruby. see -> https://github.com/s6ruby/rubidity/blob/master/contracts/simpletoken.rb



gm.

about 1)

> multiple inheritance like Solidity does so to port 
> over the "is ERC20, Ownable" type thing you need a custom system anyway

good point. the reason for the change has two points: 1) multiple inheritance is a design flaw in solidity - let's simplify - it is not needed   2)  to reuse code / methods close to "multiple-inheritance" style without the "diamonds problem" you CAN use module includes  (that will "model" to solidity contract classes WITHOUT constructors).  i think that will cover 99.99% of all use (happy to be shown an example where this doesn't work). 

about 2)

> my approach makes it easier to type check the method return value,
> but there's probably another way of doing that.

you can use the best of both worlds ;-)  - in ruby you define the typeless / untyped / unsafe function / method  BUT thanks to ruby meta-programming magic/fu you can rename the method to  `<name>_unsafe` or such and than auto-add a new method (wrapper) with the orginal name handling the input (arguments) and output (returns) to type check (and auto-convert/cast) "automagically".    anyways, i try to support the "classic" original function-style in a rubidity classic version  (the only thing i cannot support / backport / monkey patch is the classic inheritance with the "is class-macro"  otherwise  - the idea is that you can pick "classic" style or the more rubish-style.

i am trying to follow and catch-up and learn  while trying to (re)build a more simpler / minimalistic version  (today i try to kill / delete the state proxy class  by using "plain" instance (object) variables). ps: i have started to document (collect notes on) classic vs (more) ruby-ish style here -> https://github.com/s6ruby/rubidity/tree/master/rubidity-classic#whats-different


one more (radical more ruby-ish) syntax idea / proposal ...
now contract storage (state) variable get declared like:

``` ruby
string :name
string :symbol
uint   :decimals
uint   :totalSupply
mapping [:address, :uint], :balanceOf 
```

now how to make this more ruby-ish?  the radical idea is turn all (solidity) types into real (ruby) types and  ALWAYS use real type classes. 
the new contract storage (state) variable declaration becomes:

``` ruby
storage  name:         String,
               symbol:       String,
               decimals:     Uint,
               totalSupply:  Uint,
               balanceOf:    Mapping( Address, Uint )
```   

and an event declartion looks like: 

``` ruby
event :Transfer, { from:   Address, 
                   to:     Address, 
                   amount: Uint } 
```

and a typed function / method with sig(nature) annotation like:

``` ruby
sig [Address, Uint], returns: Bool, 
def transfer( to:, amount: )
    #...
end 
```

anyways, i try to make the new style work in the next days. so far using ivars (instance variables) for storage / state has been working out great and makes the (contract) code again more ruby-ish e.g. changing  `s.name` or `s.symbol` or such to `@name` and `@symbol` and making the "under-the-hood" machinery simpler (maybe i am missing something  - let's explore). it's still (very) early.  


gm.

little update on rubidity i am super excited.
in the "classic" original version inheritance "models" solidity with is "keyword" e.g.:

``` ruby
class PublicMintERC20 < ContractImplementation
  is :ERC20 
  # ...
end
```

why not (re)use the ruby machinery and inheritance model and get everything for free - the idea (design philosophy) of the (alternate) rubidity i am working on in the sandbox is - it is just ruby (yes, with 100%-compatibility for solidity for api / abi and storage  / state).
anyways, the updated version reads:

``` ruby
class PublicMintERC20 < ERC20 
  # ...
end
```

while i am at it to align rubidity more with ruby itself - i am also renaming require()  - which has special meaning in ruby (it is basically the import for package / module / gem / library reuse) to assert so you can (continue to) use require in rubidity.
sorry if that's too much detail. it's still (very) early.

one more biggie update (idea / proposal)
in classic a typed method / function looks like:

``` ruby
function :airdrop, { to: :addressOrDumbContract, amount: :uint256 }, :public do
  # ...
end
```

to align rubidity more with ruby itself - lets use "plain" methods and add an (optional) type sig(nature) annotation resulting in: 

``` ruby
sig :airdrop, [:addressOrDumbContract, :uint256], :public
def airdrop( to:, amount: ) 
 # ...
end
```

see https://github.com/s6ruby/rubidity/blob/master/rubidity-contracts/lib/rubidity/contracts/public_mint_erc20.rb for a contract sample in the new (syntax) style for functions. 

while this may look like hair-splitting about syntax. the new way is ruby all the way down (using an "alias method chain" for the typed and untyped methods). no need to (re)generate methods from super classes and such and because it's ruby the rdoc (documentation) works too. see here how it looks like in classic (hint: you see nothing) -> https://www.rubydoc.info/gems/rubidity-contracts/0.2.0/PublicMintERC20   and compare to the update (v.0.2.1) -> https://www.rubydoc.info/gems/rubidity-contracts/0.2.1/PublicMintERC20   it's still (very) early. 


gm.

about 1) i am for sure no big "test guy" either but since i kind of work "backwards", that is, i start with your (original) code and than try to make it all simpler and more robust (if i dare to say) while trying to keep the same functionality i started adding some tests.    about rspec vs "plain" tests i am using "plain" tests (that's my philosophy) that is, use the simpler / easier way.   i'd say use rspecs if that feels more natural and easier to you.  again for me the "rspec sugar syntax icing on the cake" or whatever is unnecessary extra fluff but again i won't stop anyone from using it.  sorry to hear that chatGPT is promoting rspec ;-) (instead of "plain" tests). 

about 2)   great to see an alias for uint / uint256 an int / int256 in rubidity.   uint256 is super import for abis that is if you export the contract abi uint "automagically" must be turned into uint256 (there's no uint type in abi) but yes, i wouldn't force people to use uint256 in rubidity itself.

about 3)   making public the default AND internal EXPLICIT with leading underscores i guess we must agree to disagree.   in ruby methods are public by default but the real biggie in my opinion is that shorter code is better. anyways,  no harm since in all your contract code you always add :public or :internal and that will continue to work in the (alternate) rubidity  (with the new option of using shortcuts to make the code shorter and easier to read).    and i am with you 100% the interface and storage / state MUST be 100% compatible with solidity. but again i am in favor of making (rubidity) code easier / simpler to read / write.    anyways, please keep going with your design and sorry for taking up your time here. really love it all and amazing that it is all working and live.  i will follow and try to keep-up.  the idea is that i try to experiment in my little (alternate) rubidity sandbox and back-up ideas / proposals with working code.

about 4)   thanks for update. i will follow and try to keep-up.  the idea of my little (alternate) rubidity is to stay compatible 100% with the contract language BUT the under-the-hood machinery is different ( no method_missing, no proxies, etc.) with the idea of being as minimalistic as can be (with the idea that simpler is more robust and so on). 

ps:  yes, about looking (in upcoming weeks)  into a shared contract testing set - for 1) high-level contracts and maybe 2)  low-level types  - maybe one idea is to use json and (plain) text   - than everyone can use it no matter what language (not even ruby required) and rspec vs minitest ("plain" test) also irrelevant.

but again you are the superstar - there is zero interest in rubidity itself.

it all depends on ethscriptions and ethscription vm going live than i think interest like javascript (in the browser) will come "naturally" because it is the default language.   (of course - most will not care about the details  because (re)use of (standard / built-in) contracts is the killer feature) - starting a new token (with contract) with a simple text scribe (ethscription).

gm.

the PublicMintERC20 contract test script is now a proper (unit) test shipping with the rubidity-contracts gem. see the test script in test/ here -> https://github.com/s6ruby/rubidity/blob/master/rubidity-contracts/test/test_public_mint_erc20.rb   it's still (very) early.   the test result reads:

> 2 runs, 15 assertions, 0 failures, 0 errors, 0 skips 



gm.

a little rubidity (the gem edition) update -  the PublicMintERC20 contract now works with the rubidity gem. see the test script sample in the sandbox here -> https://github.com/s6ruby/rubidity/blob/master/rubidity-contracts/sandbox/public_mint_erc20.rb  it's still (very) early if anyone is interested in what i am doing here, please say hello. 
here's an idea / proposal to make the contract code easier to read.   let's make all functions public by default and all functions starting with underscore (`_`) internal by default and same for storage / state variables.  in the standard contracts this convention is already used (but without the defaults). why not make it part of the rubidity language?  big benefit - less code and easier to read.  example: 

``` ruby
string :public, :name
string :public, :symbol
uint256 :public, :decimals
```

becomes

``` ruby
string  :name
string  :symbol
uint256  :decimals
```

and

``` ruby
function :_mint, { to: :addressOrDumbContract, amount: :uint256 }, :internal, :virtual
function :_mint, { to: :addressOrDumbContract, amount: :uint256 }, :virtual
```

or

``` ruby
function :transfer, { to: :addressOrDumbContract, amount: :uint256 }, :public, :virtual, returns: :bool
function :transfer, { to: :addressOrDumbContract, amount: :uint256 }, :virtual, returns: :bool
```

i know in functions the differance looks little but if you look at dozens of functions that will all add up .   i have a (more radical) idea / proposal to make function easier to read / shorter but lets do it one step at a time. 
while posting ideas / proposals - one more.  i suggest using uint and int as a type alias for uint256 and int256   that will make the code shorter and more beautiful.  anyways, that's it. again love rubidity.

ps:  i tried to reach out the ruby community (via rubyflow) see here -> https://rubyflow.com/p/ba3ovg-rubidity-gem-ruby-for-layer-l1-contracts-protocols-language-machinery   or here ->  https://rubyflow.com/p/ct0zt9-rubidity-typed-gem-zero-dependency-type-machinery-for-rubidity    - alas so far i think the interest is zero  (lots of crypto haters in rubyland and the rest is all about rails).  anyways, i keep trying.  have a great weekend.

for reference here's the rubidity gem page -> https://rubygems.org/gems/rubidity   latest downloads stats and more. wen 1000 downloads?




gm.

> I love it! Looks so official! Let me know if I can help!

Thanks for the kind words.   Give me another week to update the (rubidity) gems and learn / study to see if the "thesis" is working out (that is, that i can get a (basic) "gem-ified" / modular version to work). it's still early. big fan of (contract) examples-driven. so more dumb contracts always help.   keep going with what you do (not trying to take up any of your time). love it.  i try to catch-up / follow. 

gm.

I don't have the definite answers and i am learning by doing / coding.  The idea is to use your set / samples of (dumb) contracts and make them run with the new rubidity gem. i got the first (token) contract  running today but still (very) early.   fun trivia. i bundled up the (standard) contracts into a gem here (rubidity-contracts) -> https://www.rubydoc.info/gems/rubidity-contracts   looks like i need to work more to make some code show up with the standard rdoc / yard tooling. lol.   i try to push more updates tomorrow.



gm.

> but age = TypedVariable.create(:uint256, 100)
>  is too far!

i understand. this is the "low-level" machinery.  the idea is to offer global type methods e.g. 

``` ruby
age = uint256( 100 )
```

that gets you a typed uint256 literal in age. tha actual "long-form" syntax for now is:

``` ruby
age = TypedUint256.new( 100 )
```

that is, every type has a `Typed<Type>` class.
another idea is to use a prefix for integers e.g.

``` ruby
age = 100.u       # or  
age = 100.u256
```

not sure either probably best the most simple:

``` ruby
age = 100
```

only check type in storage and public exported function arguments (and on returns). about

> I'm not sure about killing the proxies. 
> If you want to keep the "type + value" basic setup, 
> which I think is good, then you can't count on ruby values
>  being able to give the desired behavior. 

I am with you. You are misunderstanding the setup.  The `TypedArray` IS the proxy and has a `@data` embedded for the array - all access goes through `TypedArray` (because it IS the proxy) that defines the array interface explicitily.
That is, true for all other too e.g. `TypedString`, `TypedUint`, `TypedInt`, etc.  they ARE ALL proxys by definition. there is no direct access to the ruby "standard" value.
i am not inventing anything new here. i follow your model :-).  all i am doing is removing the two-tier classes / setup for reference types AND new - give every type its own `Typed<type>` class / proxy.

it is still early (day 3) with rubidity-typed.  i try to spend some more days (iterating) and improving / expanding the code.



gm.

i am trying to make the "embedded" rubidity a.k.a. dumb contract vm more (re)usable by breaking-up into modules / gems.

a first (very early)  "zero-dependency" module / gem called rubidity-typed is now published - see https://github.com/s6ruby/rubidity/tree/master/rubidity-typed   ps:  i am trying to stay close to the original "upstream"  names / interface to allow maybe in the future (easier) "drop-in" replacement / upgrade / integration.

for now the plan is that i dedicate a week or two to explore / improve the new code / modules. 
for example - with the new typed system you can use typed variables "stand-alone"  e.g. `TypedString.new`, `TypedArray.new( sub_type: string )`, and so on.   The idea is to make it all more robust and easier to use.  

Note, for example, for `TypedArray` there's no more two-tier setup with `TypedArray`+`ArrayProxy` it's `TypedArray` only same for `TypedMapping` and one "biggie" idea is to make the new type "magic" all possible WITHOUT any method_missing magic by "explicitly" delegating what method you want to support for every type - that is - more work but i think in the end more robust.  Anyways, not sure if that makes sense to anyone. Still early.


gm.

thanks for the offer. i don't want to take up your time (for now i try to learn by studying / (re)using your code). keep going. i try to catch-up / follow.   a first "zero-dependency" module / gem called rubidity-typed is now published - see https://github.com/s6ruby/rubidity/tree/master/rubidity-typed   ps:  i am trying to stay close to your names / interface to allow maybe in the future (easier) "drop-in" replacement / upgrade / integration


gm.

again thanks for the welcome.
yeah no worries - big fan too of monotrees and monoliths. 

yeah you are right of keeping it in one place - it is amazing what you have done and focus on delivering and being productive and shipping.  sorry for the misunderstanding - the rubidity sandbox is for "experiments" and i am trying to learn more about rubidity by doing / coding (and sharing).

about the l1 blockchain scaling. i am with you. amazing what you have already done. it's the future (cheaper, simpler, easier) - the most important being the cheaper part ;-).  and sure the best way is to deliver and more people will understand.

about collaborating. let me study your code for another week and work in the (rubidity) sandbox and than check back. thanks again for the incredible welcome. keep up the great work. 


gm.

thanks for the invite.
still trying to catch-up and learn more (about ethscriptions infrastructure).    for now my main idea / project is to try to "break-up" the rails ethscriptions vm monolith and "produce" maybe a couple of (re)useable gems for rubidity. the rubyidity (work-in-progress) sandbox for reference is here  ->  https://github.com/s6ruby/rubidity 


