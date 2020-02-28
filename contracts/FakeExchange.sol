pragma solidity ^0.6.0;

//import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/ownership/Ownable.sol";
import "../lib/openzeppelin/contracts/ownership/Ownable.sol";

/**
 * @dev ERC20 interface that allows to interact with different tokens abstracting from their implementation
 **/
contract ERC20 {

    function totalSupply() public view returns (uint) {}
    function balanceOf(address tokenOwner) public view returns (uint balance) {}
    function allowance(address tokenOwner, address spender) public view returns (uint remaining){}
    function transfer(address to, uint tokens) public returns (bool success) {}
    function approve(address spender, uint tokens) public returns (bool success) {}
    function transferFrom(address from, address to, uint tokens) public returns (bool success) {}

}

/**
 * @title FakeExchange
 **/
contract FakeExchange is Ownable {
    
    ERC20 stub; ///stub for interactions with ERC20 token contracts
    uint buyFee; ///exchange fee for users purchases
    uint sellFee; ///exchange fee for users sales

    event TokenSold(address customer,uint qty,uint price); ///event emitted on tokens purchases
    event TokenBought(address seller, uint qty, uint price); ///event emitted on tokens sales
    event TokenAddressChanged(string tokenID, string addressType, address newAddress); ///event emitted when one of the token addresses has been modified
    event TokenDeleted(string tokenID); ///event emitted when a token has been deleted
    event FeeChanged(string feeType,uint newValue); ///event emitted when exchange sellFee or buyFee has been modified
    event Deposit(uint amount, address from); ///event emitted on deposit
    event Withdrawal(uint amount, address from); ///event emitted on withdrawal
    
    constructor () public {
        sellFee = 100;
        buyFee = 100;
        emit FeeChanged("SELL",sellFee);
        emit FeeChanged("BUY",buyFee);
    }
    
    struct Token {
        string id; ///token identifier
        address tokenAddress; ///token contract address
        address bankAddress; ///address from which tokens are transfered during exchange sales
        address payable payAddress; ///address to send to ETH-buyFee after tokens have been sold
        bool supported; ///if exchange supports this token or not
    }

    mapping(string => Token) supportedCoins; ///mapping to track supported tokens
    
    /**
     * @dev add a new supported token (callable only by exchange owner)
     * @param id token identifier
     * @param tokenAddr token contract address
     * @param bankAddr token bank address
     * @param payAddr token pay address
     **/
    function addToken(string memory id,address tokenAddr,address bankAddr,address payable payAddr) onlyOwner public {
        require(supportedCoins[id].supported == false, "coin already supported");
        supportedCoins[id] = Token(id,tokenAddr,bankAddr,payAddr,true);
    }
    
    /**
     * @dev remove supported token (callable only by exchange owner)
     * @param id token identifier
     **/
    function removeToken(string memory id) public onlyOwner {
        supportedCoins[id].supported = false;
        emit TokenDeleted(id);
    }
    
    /**
     * @dev set new bank address on an existing token (callable only by exchange owner)
     * @param id token identifier
     * @param bankAddr new bank address
     **/
    function setBankAddr(string memory id,address bankAddr) public onlyOwner {
        require(supportedCoins[id].supported == true, "coin not supported");
        supportedCoins[id].bankAddress = bankAddr;
        emit TokenAddressChanged(id, "BANK", bankAddr);
    }
    
    /**
     * @dev set new pay address on an existing token (callable only by exchange owner)
     * @param id token identifier
     * @param payAddr new pay address
     **/
    function setPayAddr(string memory id,address payable payAddr) public onlyOwner {
        require(supportedCoins[id].supported == true, "coin not supported");
        supportedCoins[id].payAddress = payAddr;
        emit TokenAddressChanged(id, "PAY", payAddr);
    }
    
    /**
     * @dev getter for token pay address (callable only by exchange owner)
     * @param id token identifier
     * @return token pay address
     **/
    function getPayAddr(string memory id) public view onlyOwner returns (address) {
        require(supportedCoins[id].supported == true, "coin not supported");
        return supportedCoins[id].payAddress;
    }
    
    /**
     * @dev getter for token bank address (callable only by exchange owner)
     * @param id token identifier
     * @return token bank address
     **/
    function getBankAddr(string memory id) public view onlyOwner returns (address) {
        require(supportedCoins[id].supported == true, "coin not supported");
        return supportedCoins[id].bankAddress;
    }
    
    /**
     * @dev getter for token contract address
     * @param id token identifier
     * @return token contract address
     **/
    function getTokenAddr(string memory id) public view returns (address) {
        require(supportedCoins[id].supported == true, "coin not supported");
        return supportedCoins[id].tokenAddress;
    }
    
    /**
     * @dev set exchange buyFee (callable only by exchange owner)
     * @param newFee new fee 
     **/
    function setBuyFee(uint newFee) public onlyOwner {
        buyFee = newFee;
        emit FeeChanged("BUY",newFee);
    }
    
    /**
     * @dev set exchange sellFee (callable only by exchange owner)
     * @param newFee new fee 
     **/
    function setSellFee(uint newFee) public onlyOwner {
        sellFee = newFee;
        emit FeeChanged("SELL",newFee);
    }
    
    /**
     * @dev getter for buy fee
     * @return buyFee
     **/
    function getBuyFee() public view returns (uint) {
        return buyFee;
    }
    
    /**
     * @dev getter for sell fee
     * @return sellFee
     **/
    function getSellFee() public view returns (uint) {
        return sellFee;
    }
    
    /**
     * @dev get token price (in a real-life scenario should be implemented with some logic)
     * @param id token identifier
     * @return token price (in ETH)
     **/
    function getPrice(string memory id) pure internal returns(uint256){
        return 100;
    }
    
    /**
     * @dev buy tokens
     * @param id token identifier
     * @param qty amount 
     **/
    function buy(string memory id, uint qty) payable public {
        require(supportedCoins[id].supported == true, "coin not supported");
        require(msg.value >= qty * getPrice(id), "not enough ETH supplied");
        stub = ERC20(supportedCoins[id].tokenAddress); ///loading token contract instance in ERC20 stub
        bool result = stub.transferFrom(supportedCoins[id].bankAddress,msg.sender,qty);
        require(result == true,"tokens transfer failed");
        supportedCoins[id].payAddress.transfer(msg.value - buyFee); ///pay token contract and get fee
        emit TokenSold(msg.sender,qty,msg.value);
    }
    
    /**
     * @dev sell tokens
     * @param id token identifier
     * @param qty amount
     **/
    function sell(string memory id, uint qty) public {
        require(supportedCoins[id].supported == true, "coin not supported"); //check if this coin is supported
        require(address(this).balance >= qty * getPrice(id),"contract hasn't enough ETH"); //check if this contract has enough ETH to buy
        stub = ERC20(supportedCoins[id].tokenAddress);
        bool result = stub.transferFrom(msg.sender,address(this),qty);
        require(result == true, "token transfer failed"); //check that token transfer has been successful
        uint price = qty * getPrice(id);
        msg.sender.transfer(price - sellFee); //pay seller
        emit TokenBought(msg.sender,qty,price);
    }
    
    /**
     * @dev get exchange current balance
     * @return exchange balance
     **/
    function balance() public view returns (uint){
        return address(this).balance;
    }
    
    /**
     * @dev transfer ETH to exchange
     **/
    function deposit() public payable {
	    emit Deposit(msg.value,msg.sender);
    }
    
    /**
     * @dev withdraw ETH from exchange (callable only by exchange owner)
     * @param amount qty to withdraw
     **/
    function withdraw(uint256 amount) external onlyOwner {
        require(amount <= address(this).balance);
        msg.sender.transfer(amount);
    	emit Withdrawal(amount,msg.sender);
    } 
    
    receive() external payable {}
    
    fallback() external payable {}


}
