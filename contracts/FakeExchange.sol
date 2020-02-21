pragma solidity ^0.6.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/ownership/Ownable.sol";

contract ERC20 {

    function totalSupply() public view returns (uint) {}
    function balanceOf(address tokenOwner) public view returns (uint balance) {}
    function allowance(address tokenOwner, address spender) public view returns (uint remaining){}
    function transfer(address to, uint tokens) public returns (bool success) {}
    function approve(address spender, uint tokens) public returns (bool success) {}
    function transferFrom(address from, address to, uint tokens) public returns (bool success) {}

}


contract FakeExchange is Ownable {
    
    ERC20 stub;
    uint fee = 100;

    event CoinSold(address customer,uint qty,uint price);
    event CoinBought(address seller, uint qty, uint price);
    
    struct Token {
        address addr;
        uint price;
        bool supported;
    }

    mapping(string => Token) supportedCoins;

    function addCoin(address contractAddr, string memory symbol, uint price) onlyOwner public {
        require(supportedCoins[symbol].supported == false, "coin already supported");
        supportedCoins[symbol] = Token(contractAddr,price,true);
    }

    function buy(string memory symbol, uint qty) payable public {
        require(supportedCoins[symbol].supported == true, "coin not supported"); //check if this coin is supported
        require(msg.value >= qty * supportedCoins[symbol].price, "not enough ETH supplied"); //check if supplied ETH is enough
        stub = ERC20(supportedCoins[symbol].addr);
        bool result = stub.transferFrom(supportedCoins[symbol].addr,msg.sender,qty);
        require(result == true); //check that token transfer has been successful
        msg.sender.transfer(msg.value - fee); //pay token contract and get fee
        emit CoinSold(msg.sender,qty,msg.value);
    }

    function sell(string memory symbol, uint qty) public {
        require(supportedCoins[symbol].supported == true, "coin not supported"); //check if this coin is supported
        require(address(this).balance >= qty * supportedCoins[symbol].price); //check if this contract has enough ETH to buy
        stub = ERC20(supportedCoins[symbol].addr);
        bool result = stub.transferFrom(msg.sender,address(this),qty);
        require(result == true); //check that token transfer has been successful
        uint price = qty * supportedCoins[symbol].price;
        msg.sender.transfer(price - fee); //pay seller
        emit CoinBought(msg.sender,qty,price);
    }


}
