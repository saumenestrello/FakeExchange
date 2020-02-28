pragma solidity ^0.6.0;

//import "http://github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "../lib/openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * @title FakeCoin
 **/
contract FakeCoin is ERC20{
    
    address owner; ///contract owner
    string public constant name = 'FakeCoin'; ///token name
    string public constant symbol = 'FC'; ///token ID
    uint8 public decimals = 0; ///token cannot be subdivided
    uint public constant INITIAL_SUPPLY = 20000000; ///initial supply given to contract owner

    constructor () public {
        owner = msg.sender;
        _mint(msg.sender, INITIAL_SUPPLY); ///mint INITIAL_SUPPLY and give it to contract owner
    }
    
    /**
     * @dev callable ony by contract owner, it allows to withdraw from contract ETH balance
     * @param qty amount to withdraw
     **/
    function withdraw(uint qty) public {
        require(msg.sender == owner, "unauthorized address");
        msg.sender.transfer(qty);
    }
    
    receive() external payable {}
    
    fallback() external payable {}

}
