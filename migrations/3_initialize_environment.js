const FakeExchange = artifacts.require("./FakeExchange.sol");

 module.exports = function(deployer,network,accounts) {
      deployer.then(async () => {
      const coinbase = accounts[2];
      console.log(' > coinbase: ' + coinbase);
      let e = await FakeExchange.deployed().then(async (instance) => {
             console.log(' > exchange: ' + instance.address);
            //let r1 = await instance.deposit.sendTransaction({from: coinbase,value: 5000000});
           // console.log(' > deposito numero 2 su Exchange eseguito con status ' + r1.receipt.status + ' - tx:' + r1.tx);
            await instance.deposit.sendTransaction({from: coinbase,value: 5000000000}).then(async () => {
                  console.log(' > trasferiti 5000000000 wei da coinbase a exchange');
                  await instance.balance().then((balance) => {console.log(' > nuovo saldo: ' + balance)} );
            });

      });  
   });
} 
