pragma solidity ^0.6.0;

import "http://github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "http://github.com/OpenZeppelin/openzeppelin-solidity/contracts/ownership/Ownable.sol"; 

contract FakeCoin is ERC20{
    
    address owner;
    string public constant name = 'FakeCoin';
    string public constant symbol = 'FC';
    uint8 public decimals = 0;
    uint public constant INITIAL_SUPPLY = 20000000;

    constructor () public {
        owner = msg.sender;
        //create initial token offer
        _mint(address(this), INITIAL_SUPPLY);
    }
    
    function approve(address spender, uint256 amount) public override returns (bool) {
        _approve(address(this), spender, amount);
        return true;
    }
    
    function deposit(uint qty) public {
        require(msg.sender == owner, "address not authorized");
        msg.sender.transfer(qty);
    }

}
