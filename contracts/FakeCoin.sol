pragma solidity ^0.6.0;

import "http://github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "http://github.com/OpenZeppelin/openzeppelin-solidity/contracts/ownership/Ownable.sol"; 

contract FakeCoin is ERC20{
    
    address owner;
    string public constant name = 'FakeCoin';
    string public constant symbol = 'FC';
    uint256 private _totalSupply;
    
    mapping (address => uint256) private _balances;
    mapping (address => mapping (address => uint256)) private _allowances;

    constructor () public {
        owner = msg.sender;
        //create initial token offer
        _mint(address(this), 2100000000);
    }
    
    function _approve(address tokenOwner, address spender, uint256 amount) internal override {
        require(tokenOwner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[tokenOwner][spender] = amount;
        emit Approval(tokenOwner, spender, amount);
    }

}
