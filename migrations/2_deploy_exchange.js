const FakeExchange = artifacts.require("./FakeExchange.sol");

module.exports = function(deployer) {
  deployer.deploy(FakeExchange);
};

