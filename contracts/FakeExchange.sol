pragma solidity ^0.6.0;

import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/ownership/Ownable.sol";
import  'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol';


contract FakeExchange is Ownable {

    event CoinSold(address customer,uint qty,uint price);
    event CoinBought(address seller, uint qty, uint price);

    struct Coin {
     address contract_;
     uint gweiPrice;
     string name;
     string symbol;
     bool supported;
     bool canBuy;
    }

    mapping(string => Coin) supportedCoins_; //mapping to store coin infos and amount

    function addCoin(address contractAddr, uint gweiPrice, string memory name, string memory symbol) onlyOwner public {
        require(this.supportedCoins_[symbol].supported == false, "coin already supported");
        Coin memory newCoin = Coin(contractAddr,gweiPrice,name,symbol,true);
        this.supportedCoins_[symbol] = newCoin;
    }

    function buy(string memory symbol, uint qty) payable public {
        Coin memory coin = supportedCoins_[symbol];
        require(coin.supported == true, "coin not supported"); //check if this coin is supported
        require(msg.value >= qty * coin.gweiPrice); //check supplied ETH
        ECR20 memory tokenContract = ECR20(coin.contract_);
        bool result = tokenContract.transferFrom(coin.contract_,msg.sender,qty);
        require(result == true); //check that token transfer has been successful
        emit CoinSold(msg.sender,qty,msg.value);
    }

    function sell(string memory symbol, uint qty) public {
        Coin memory coin = supportedCoins_[symbol];
        require(coin.supported == true, "coin not supported"); //check if this coin is supported
        require(address(this).balance >= qty * coin.gweiPrice); //check supplied ETH
        require(coin.canBuy == true);
        ECR20 memory tokenContract = ECR20(coin.contract_);
        bool result = tokenContract.transferFrom(msg.sender,address(this),qty);
        require(result == true); //check that token transfer has been successful
        uint price = qty * coin.gweiPrice;
        msg.sender.transfer(price); //pay seller
        emit CoinBought(msg.sender,qty,price);
    }

    function setCanBuy(string memory symbol, bool value) onlyOwner public  {
        Coin memory coin = supportedCoins_[symbol];
        require(coin.supported == true, "coin not supported"); //check if this coin is supported
        coin.canBuy = value;
    }


}
