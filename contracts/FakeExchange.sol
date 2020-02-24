pragma solidity ^0.6.0;

//import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/ownership/Ownable.sol";
import "../lib/openzeppelin/contracts/ownership/Ownable.sol";

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
    uint fee;

    event TokenSold(address customer,uint qty,uint price);
    event TokenBought(address seller, uint qty, uint price);
    event TokenAddressChanged(string tokenID, string addressType, address newAddress);
    event TokenDeleted(string tokenID);
    event FeeChanged(uint newValue);
    
    constructor () public {
        fee = 100;
        emit FeeChanged(100);
    }
    
    struct Token {
        string id;
        address tokenAddress;
        address bankAddress;
        address payable payAddress;
        bool supported;
    }

    mapping(string => Token) supportedCoins;

    function addToken(string memory id,address tokenAddr,address bankAddr,address payable payAddr) onlyOwner public {
        require(supportedCoins[id].supported == false, "coin already supported");
        supportedCoins[id] = Token(id,tokenAddr,bankAddr,payAddr,true);
    }
    
    function removeToken(string memory id) public onlyOwner {
        supportedCoins[id].supported = false;
        emit TokenDeleted(id);
    }
    
    function setBankAddr(string memory id,address bankAddr) public onlyOwner {
        supportedCoins[id].bankAddress = bankAddr;
        emit TokenAddressChanged(id, "BANK", bankAddr);
    }
    
    function setPayAddr(string memory id,address payable payAddr) public onlyOwner {
        supportedCoins[id].payAddress = payAddr;
        emit TokenAddressChanged(id, "PAY", payAddr);
    }
    
    function setFee(uint newFee) public onlyOwner {
        fee = newFee;
        emit FeeChanged(newFee);
    }
    
    function getFee() public view returns (uint) {
        return fee;
    }
    
    function getPrice(string memory id) internal returns(uint256){
        return 100;
    }

    function buy(string memory id, uint qty) payable public {
        require(supportedCoins[id].supported == true, "coin not supported"); //check if this coin is supported
        require(msg.value >= qty * getPrice(id), "not enough ETH supplied"); //check if supplied ETH is enough
        stub = ERC20(supportedCoins[id].tokenAddress);
        bool result = stub.transferFrom(supportedCoins[id].bankAddress,msg.sender,qty);
        require(result == true); //check that token transfer has been successful
        supportedCoins[id].payAddress.transfer(msg.value - fee); //pay token contract and get fee
        emit TokenSold(msg.sender,qty,msg.value);
    }

    function sell(string memory id, uint qty) public {
        require(supportedCoins[id].supported == true, "coin not supported"); //check if this coin is supported
        require(address(this).balance >= qty * getPrice(id),"contract hasn't enough ETH"); //check if this contract has enough ETH to buy
        stub = ERC20(supportedCoins[id].tokenAddress);
        bool result = stub.transferFrom(msg.sender,address(this),qty);
        require(result == true, "token transfer failed"); //check that token transfer has been successful
        uint price = qty * getPrice(id);
        msg.sender.call.value(price - fee)(""); //pay seller
        emit TokenBought(msg.sender,qty,price);
    }
    
    function balance () public view onlyOwner returns (uint){
        return address(this).balance;
    }
    
    
    receive() external payable {}
    
    fallback() external payable {}


}
