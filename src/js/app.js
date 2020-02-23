


App = {
  web3Provider: null,
  contracts: {},
  binstance : null,
  account: '0x0',
  wsURL : 'http://192.168.1.173:8080/batch/get',
  ethURL : 'http://192.168.1.173:7545',

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
    var loader = $("#loader");
    var content = $("#content");

    var proofs = $("#proofs");
    proofs.empty();
    var proofTemplate = '<tr><td align="center" colspan="7">No data</td></tr>';
    proofs.append(proofTemplate);

    loader.show();
    content.hide();

    // Load account data
    web3.eth.getCoinbase(function (err, account) {
      if (err === null) {
        App.account = account;
        $("#accountAddress").html("Your Account: " + account);
      }
    });

    // Load contract data
    App.contracts.FakeExchange.deployed().then(function (instance) {

      App.bInstance = instance;
      console.log(instance);

      return App.bInstance;
    }).then(function () {

      loader.hide();
      content.show();
    }).catch(function (error) {
      console.warn(error);
    });
  }
};

function loadBatchProofs(data){

  var proofs = $("#proofs");
  proofs.empty();

  if(data === ''){
    alert('The required batch does not exist');
    var proofs = $("#proofs");
    proofs.empty();
    var proofTemplate = '<tr><td align="center" colspan="7">No data</td></tr>';
    proofs.append(proofTemplate);
    return;
  }

  var obj = JSON.parse(data);

  var batch = obj.batch;
  var ckps = [];
  ckps = obj.list;

  for (var i = 0; i < ckps.length; i++) {

    var id = ckps[i].id;
    var timestamp = ckps[i].timestamp;
    var type = ckps[i].type;
    var place = ckps[i].place;
    var material = ckps[i].material;
    //var hash = ckps[i].hash;
    
    var dataString = batch + type + place + material + timestamp;
    var hash = doHash(dataString);

    var bcProof = App.bInstance.getProofHash(batch, id).then(function (res) {

      if (res == hash) {
        var proofTemplate = "<tr><th>" + id + "</th><td>"  + timestamp + "</td><td>" + place + "</td> <td>" + type + "</td> <td>" + hash + "</td> <td>" + res + "</td><td><img class=status-img src=images/ok.png /></td></tr>";
        proofs.append(proofTemplate);
      } else {
        var proofTemplate = "<tr><th>" + id + "</th><td>"  + timestamp + "</td><td>" + place + "</td> <td>" + type + "</td> <td>" + hash + "</td> <td>" + res + "</td><td><img class=status-img src=images/ko.png /></td></tr>";
        proofs.append(proofTemplate);
      }

    });

  }

}

function loadData(){

  var url = App.wsURL;
  var batchId = $("#batch").val();
  var param = 'data=' + parseInt(batchId);


  $.ajax({

    'url' : url,
    'type' : 'GET',
    'contentType' : 'application/x-www-form-urlencoded',
    'data' : param,
    'success' : function(data) {              
        loadBatchProofs(data);
    },
    'error' : function(request,error)
    {
        alert('A communication error occured: can\'t retrieve batch infos');
        var proofs = $("#proofs");
        proofs.empty();
        var proofTemplate = '<tr><td align="center" colspan="7">No data</td></tr>';
        proofs.append(proofTemplate);
    }
});

}

function doHash(str){
  const CryptoJS = require('crypto-js');
  var hash = CryptoJS.SHA256(str);
  return hash.toString();
}

$(function () {
  $(window).load(function () {
    App.init();
  });
});