const FakeExchange = artifacts.require("./FakeExchange.sol");
const FakeCoin = artifacts.require("FakeCoin");
const c1ApproveQty = 50;
const c1ID = 'FC';


module.exports = function(deployer,network,accounts) {
  deployer.then(async () => {

      const exchangeOwner = accounts[0];
      const c1Owner = accounts[1];
      const coin1Bank = accounts[1];
      const coinbase = accounts[2];

        await deployer.deploy(FakeExchange,{ from: exchangeOwner}).then(() => FakeExchange.deployed()).then(async (e) => {
        await deployer.deploy(FakeCoin,{from: c1Owner}).then(() => FakeCoin.deployed()).then(async (c1) => {
         
          await e.addToken.sendTransaction(c1ID,c1.address,coin1Bank,coin1Bank,{from:exchangeOwner}).then(async (r) => {
            console.log(' > aggiunta coin su Exchange eseguita con status ' + r.receipt.status + ' - tx:' + r.tx);
          });
     
          await c1.approve.sendTransaction(e.address,c1ApproveQty,{from:coin1Bank}).then(async (r) => {
            console.log(' > creazione allowance su coin per Exchange eseguita con status ' + r.receipt.status + ' - tx:' + r.tx);
          }); 
        });
      });
  })
} 
