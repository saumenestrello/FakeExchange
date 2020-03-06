pragma solidity ^0.6.0;

//import "http://github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "../lib/openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * @title EzCash
 **/
contract EzCash is ERC20{
    
    string public constant name = 'EzCash'; ///token name
    string public constant symbol = 'EC'; ///token ID
    uint8 public decimals = 0; ///token cannot be subdivided
    uint public constant TOTAL_SUPPLY = 300000000000; ///total supply given to the bank, it's not possible to mint other tokens
    address payable bank;
    bool alreadyMinted = false;
    
    mapping (address => uint256) private _balances;
    mapping (address => mapping (address => uint256)) private _allowances;

    constructor (address payable bankAddr) public {
        bank = bankAddr;
        mint(bankAddr, TOTAL_SUPPLY); ///mint INITIAL_SUPPLY and give it to contract owner
        alreadyMinted = true;
    }
    
    function mint(address account, uint256 amount) internal {
        require(account == bank, "minting is allowed to bank only");
        require(alreadyMinted == false, "minting is allowed only once during contract creation");
        super._mint(account,amount);
    }
    
    receive() external payable {
        bank.transfer(msg.value);
    }
    
    fallback() external payable {
        bank.transfer(msg.value);
    }

}