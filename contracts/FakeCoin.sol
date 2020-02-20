pragma solidity ^0.4.21;

import 'openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol';
import 'openzeppelin-solidity/contracts/ownership/Ownable.sol';

contract FakeCoin is StandardToken, Ownable {

    string public constant name = 'FakeCoin';
    string public constant symbol = 'FC';
    uint8 public constant decimals = 2;
    uint constant _initial_supply = 2100000000;
    uint gweiPrice = 10000;

    function FakeCoin() public {
        totalSupply_ = _initial_supply;
        //give 100000 FC to the creator of the contract
        transfer(msg.sender,100000);
        emit Transfer(address(0), msg.sender, 100000);
    }

    function setPrice(uint gweiPrice) public onlyOwner {
        this.gweiPrice = gweiPrice;
    }

    function approve(address _spender, uint256 _value) public onlyOwner returns (bool) {
        return super.approve(_spender,_value);
    }

    function increaseApproval(address _spender, uint256 _addedValue) public onlyOwner returns (bool) {
        return super.increaseApproval(_spender,_addedvalue);
    }

    function decreaseApproval(address _spender, uint256 _subtractedValue) public onlyOwner return (bool) {
        return super.decreaseApproval(_spender,_subtractedValue);
    }

}
