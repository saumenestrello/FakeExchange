pragma solidity ^0.6.0;

import "http://github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";

contract FakeCoin is ERC20{
    
    address owner;
    string public constant name = 'FakeCoin';
    string public constant symbol = 'FC';
    uint8 public decimals = 0;
    uint public constant INITIAL_SUPPLY = 20000000;

    constructor () public {
        owner = msg.sender;
        //create initial token offer
        _mint(msg.sender, INITIAL_SUPPLY);
    }
    
    function deposit(uint qty) public {
        require(msg.sender == owner, "unauthorized address");
        msg.sender.transfer(qty);
    }
    
    receive() external payable {}
    
    fallback() external payable {}

}
