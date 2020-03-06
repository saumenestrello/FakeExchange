const FakeExchange = artifacts.require("./FakeExchange.sol");
const FakeCoin = artifacts.require("FakeCoin");
const EzCash = artifacts.require("EzCash");
const c1ApproveQty = 50;
const c2ApproveQty = 50;
const c1ID = 'FC';
const c2ID = 'EC';


module.exports = function(deployer,network,accounts) {
  deployer.then(async () => {

      const exchangeOwner = accounts[0];
      const c1Owner = accounts[1];
      const c2Owner = accounts[2];
      const coin1Bank = accounts[1];
      const coin2Bank = accounts[3];
      const coinbase = accounts[4];

        await deployer.deploy(FakeExchange,{ from: exchangeOwner}).then(() => FakeExchange.deployed()).then(async (e) => {
        await deployer.deploy(FakeCoin,{from: c1Owner}).then(() => FakeCoin.deployed()).then(async (c1) => {
        await deployer.deploy(EzCash,coin2Bank,{from: c2Owner}).then(() => EzCash.deployed()).then(async (c2) => {
         
            await e.addToken.sendTransaction(c1ID,c1.address,coin1Bank,coin1Bank,{from:exchangeOwner}).then(async (r) => {
              console.log(' > aggiunta coin ' + c1ID + ' su Exchange eseguita con status ' + r.receipt.status + ' - tx:' + r.tx);
            });

            await e.addToken.sendTransaction(c2ID,c2.address,coin2Bank,coin2Bank,{from:exchangeOwner}).then(async (r) => {
              console.log(' > aggiunta coin ' + c2ID + ' su Exchange eseguita con status ' + r.receipt.status + ' - tx:' + r.tx);
            });
      
            await c1.approve.sendTransaction(e.address,c1ApproveQty,{from:coin1Bank}).then(async (r) => {
              console.log(' > creazione allowance su coin ' + c1ID + ' per Exchange eseguita con status ' + r.receipt.status + ' - tx:' + r.tx);
            }); 

            await c2.approve.sendTransaction(e.address,c2ApproveQty,{from:coin2Bank}).then(async (r) => {
              console.log(' > creazione allowance su coin ' + c2ID + ' per Exchange eseguita con status ' + r.receipt.status + ' - tx:' + r.tx);
            }); 

          });
        });
      });
  })
} 
