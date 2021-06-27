// SPDX-License-Identifier: MIT
// Author: @cryptovagrant1
pragma solidity >= 0.7.0 <= 0.7.4;

contract Faucet{
    
    address owner;
    uint cooldown;
    mapping (address => uint) timeouts;
    
    event DonateTo(address indexed to);
    event Deposit(address indexed from, uint amount);
    
    constructor() {
        owner = msg.sender;
        cooldown = 5;
    }
    
    //  Sends 0.1337 FTM to the sender when the faucet has enough funds
    //  Only allows one donation every 30 mintues
    function donate() external{
        
        require(address(this).balance >= 0.1337 ether, "This faucet is empty. Please check back later.");
        require(timeouts[msg.sender] <= block.timestamp - cooldown minutes, "You can request a donation once every " + cooldown + " minutes. Try again in " + (timeouts[msg.sender] + cooldown minutes - block.timestamp) + " minutes.");
        
        msg.sender.transfer(0.1337 ether);
        timeouts[msg.sender] = block.timestamp;
        
        emit DonateTo(msg.sender);
    }
    
    //  Sending Tokens to this faucet fills it up
    receive() external payable {
        emit Deposit(msg.sender, msg.value); 
    }

    function transferOwnership() public{
        require(msg.sender == owner, "Only the owner of this faucet can destroy it."); 
    } 
    
    
    //  Destroys this smart contract and sends all remaining funds to the owner
    function destroy() public{
        require(msg.sender == owner, "Only the owner of this faucet can destroy it.");
        selfdestruct(msg.sender);
    }
}
