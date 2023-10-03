/ SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.4.22 <0.9.0;
import "remix_tests.sol"; 
import "remix_accounts.sol";
import "../donations.sol";

contract testSuite is donations {
    address acc0 = TestsAccounts.getAccount(0); //owner by default
    address acc1 = TestsAccounts.getAccount(1);
    address acc2 = TestsAccounts.getAccount(2);
    address acc3 = TestsAccounts.getAccount(3);
    address recipient = TestsAccounts.getAccount(4); //recipient

    /// #value: 1000000000000000000
    /// #sender: account-1
    function donateAcc1AndCheckBalance() public payable{
        Assert.equal(msg.value, 1000000000000000000, 'value should be 1 Eth');
        donate(recipient, "Mario", "Are you a bird?");
        Assert.equal(balances_getter(recipient), 1000000000000000000, 'balances should be 1 Eth');
    }
    
    /// #value: 1000000000000000000
    /// #sender: account-2
    function donateAcc2AndCheckBalance() public payable{
        Assert.equal(msg.value, 1000000000000000000, 'value should be 1 Eth');
        donate(recipient, "Tom", "Are you a plane?");
        Assert.equal(balances_getter(recipient), 2000000000000000000, 'balances should be 2 Eth');
    }
    
    /// #value: 2000000000000000000
    /// #sender: account-3
    function donateAcc3AndCheckBalance() public payable{
        Assert.equal(msg.value, 2000000000000000000, 'value should be 1 Eth');
        donate(recipient, "Maria", "Are you a car?");
        Assert.equal(balances_getter(recipient), 4000000000000000000, 'balances should be 4 Eth');
    }
    
    /// #sender: account-4
    function withdrawDonations() public payable{
        uint initialBal = getBalance();
        withdraw();
        uint finalBal = getBalance();
        Assert.equal(finalBal-initialBal, 4000000000000000000, 'balances should be 4 Eth');
    }
}