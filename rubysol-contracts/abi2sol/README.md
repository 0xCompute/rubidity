# ABI To Solidity

generate contract interface from abi in (ERC20.json)...

``` solidity
interface ERC20 {
// 4 Transact Functions(s)
function approve(address _, uint256 _) returns (bool _);
function decreaseAllowanceUntilZero(address _, uint256 _) returns (bool _);
function transfer(address _, uint256 _) returns (bool _);
function transferFrom(address _, address _, uint256 _) returns (bool _);

// 6 Query Functions(s)
function name() view  returns (string _);
function symbol() view  returns (string _);
function decimals() view  returns (uint256 _);
function totalSupply() view  returns (uint256 _);
function balanceOf(address _) view  returns (uint256 _);
function allowance(address _, address _) view  returns (uint256 _);
}
```

generate contract interface from abi in (PublicMintERC20.json)...

``` solidity
interface PublicMintERC20 {
// 6 Transact Functions(s)
function approve(address _, uint256 _) returns (bool _);
function decreaseAllowanceUntilZero(address _, uint256 _) returns (bool _);
function transfer(address _, uint256 _) returns (bool _);
function transferFrom(address _, address _, uint256 _) returns (bool _);
function mint(uint256 _) returns ( _);
function airdrop(addressOrDumbContract _, uint256 _) returns ( _);

// 8 Query Functions(s)
function name() view  returns (string _);
function symbol() view  returns (string _);
function decimals() view  returns (uint256 _);
function totalSupply() view  returns (uint256 _);
function balanceOf(address _) view  returns (uint256 _);
function allowance(address _, address _) view  returns (uint256 _);
function maxSupply() view  returns (uint256 _);
function perMintLimit() view  returns (uint256 _);
}
```


generate contract interface from abi in (ERC721.json)...

``` solidity
interface ERC721 {
// 3 Transact Functions(s)
function approve(address _, uint256 _) returns ( _);
function setApprovalForAll(address _, bool _) returns ( _);
function transferFrom(address _, address _, uint256 _) returns ( _);

// 7 Query Functions(s)
function name() view  returns (string _);
function symbol() view  returns (string _);
function getApproved(uint256 _) view  returns (address _);
function isApprovedForAll(address _, address _) view  returns (bool _);
function ownerOf(uint256 _) view  returns (address _);
function balanceOf(address _) view  returns (uint256 _);
function tokenURI(uint256 _) view  returns (string _);
}
```


generate contract interface from abi in (GenerativeERC721.json)...

``` solidity
interface GenerativeERC721 {
// 4 Transact Functions(s)
function approve(address _, uint256 _) returns ( _);
function setApprovalForAll(address _, bool _) returns ( _);
function transferFrom(address _, address _, uint256 _) returns ( _);
function mint(uint256 _) returns ( _);

// 14 Query Functions(s)
function name() view  returns (string _);
function symbol() view  returns (string _);
function getApproved(uint256 _) view  returns (address _);
function isApprovedForAll(address _, address _) view  returns (bool _);
function ownerOf(uint256 _) view  returns (address _);
function balanceOf(address _) view  returns (uint256 _);
function tokenURI(uint256 _) view  returns (string _);
function generativeScript() view  returns (string _);
function tokenIdToSeed(uint256 _) view  returns (uint256 _);
function totalSupply() view  returns (uint256 _);
function maxSupply() view  returns (uint256 _);
function maxPerAddress() view  returns (uint256 _);
function description() view  returns (string _);
function getHTML(uint256 _) view  returns (string _);
}
```
