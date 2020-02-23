


App = {
  web3Provider: null,
  contracts: {},
  binstance : null,
  account: '0x0',
  ethURL : 'http://1227.0.0.1:7545',

  init: function () {
    return App.initWeb3();
  },

  initWeb3: function () {


    if (typeof web3 !== 'undefined') {
      // If a web3 instance is already provided by Meta Mask.
      App.web3Provider = web3.currentProvider;
      ethereum.enable();
      web3 = new Web3(web3.currentProvider);
    } else {
      // Specify default instance if no web3 instance provided
      App.web3Provider = new Web3.providers.HttpProvider(App.ethURL);
      ethereum.enable();
      web3 = new Web3(App.web3Provider);
    }
    return App.initContract();
  },

  initContract: function () {
    $.getJSON("FakeExchange.json", function (exchange) {
      // Instantiate a new truffle contract from the artifact
      App.contracts.FakeExchange = TruffleContract(exchange);
      // Connect provider to interact with contract
      App.contracts.FakeExchange.setProvider(App.web3Provider);

      return App.render();
    });
  },

  render: function () {

    // Load account data
    web3.eth.getCoinbase(function (err, account) {
      if (err === null) {
        App.account = account;
        $("#address").attr('value', account);
      }
    });

    // Load contract data
    App.contracts.FakeExchange.deployed().then(function (instance) {

      App.bInstance = instance;
      console.log(instance);

      return App.bInstance;
    }).then(function () {
    }).catch(function (error) {
      console.warn(error);
    });
  }
  
};

function buyToken(){

  var id = $('token').val();
  var qty = parseInt($('qty').val());

  App.bInstance.buy(id, qty).then(function (res) {
    alert("Action completed successfully");
    
}).catch(function (err) {alert(err)});}

function sellToken(){

  var id = $('token').val();
  var qty = parseInt($('qty').val());

  App.bInstance.buy(id, qty).then(function (res) {
    alert("Action completed successfully");
    
}).catch(function (err) {alert(err)});}

$(function () {
  //$(window).load(function () {
    App.init();
  //});
});