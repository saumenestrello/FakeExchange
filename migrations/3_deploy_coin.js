
const FakeCoin = artifacts.require("./FakeCoin.sol");

module.exports = function(deployer) {
  deployer.deploy(FakeCoin);
};

