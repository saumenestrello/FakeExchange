const FakeExchange = artifacts.require("./FakeExchange.sol");
const FakeCoin = artifacts.require("./FakeCoin.sol");

const exchange = '0x7E0f4cdaAa3aF2409185f0780b4c91FCbf431ecc';
const coin1 = '0x4a82c253E4cC8D168e9037d6Bf3C841fd0F7A5c7';

const exchangeOwner = '0xfbc4a260966B62fF3Fc9671236A246FC2447b46B';

const c1Owner = '0xfbc4a260966B62fF3Fc9671236A246FC2447b46B';
const coin1Bank = '0xfbc4a260966B62fF3Fc9671236A246FC2447b46B';
const c1ApproveQty = 50;
const c1ID = 'FC';

const coinbase = '0xca0D6397E0729cF7B4e511875Eb3041A13411b77';


module.exports = function(deployer) {
  deployer.then(async () => {
      let c1 = await deployer.deploy(FakeCoin,{ from: c1Owner});
      let e = await deployer.deploy(FakeExchange,{ from: exchangeOwner});

      e.sendTransaction({from: coinbase, to: exchange, value: 50000000000});
      e.addToken.sendTransaction(c1ID,coin1,coin1Bank,coin1Bank,{from:exchangeOwner});
      c1.approve.sendTransaction(exchange,c1ApproveQty,{from:coin1Bank}); 
  })
}