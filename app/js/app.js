function startApp() {
  var address = {
    "3" : "0x0CbF3F0EdFe8EDc4D34968a0c5c54b20C2E3C85B" // Ropsten
  }

  var current_network = web3.version.network;
  var contract = web3.eth.contract(abi).at(address[current_network]);


  console.log("Contract initialized successfully")
  var basic_keys = ["name", "age", "home", "email", "tel"]

  contract.getBasicData("name", function(error, data) {
    console.log(error, data);
  });

  contract.getBasicData("age", function(error, data) {
    console.log(error, data);
  });

  contract.getBasicData("agasde", function(error, data) {
    console.log(error, data);
  });

  contract.getSize("skills", function(error, data) {
    var skills_size = data.c[0];
    for (var i = 0; i < skills_size; ++i) {
      contract.skills(i, function(error, data) {
        console.log(i, data);
      })
    }
  })

  contract.skills(0, function(error, data) {
    console.log(error, data);
  })

}
