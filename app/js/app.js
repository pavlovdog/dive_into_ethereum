// ==========================
// ===== Draw skills ========
// ==========================
google.charts.load('current', {packages: ['corechart', 'bar']});

function drawSkills() {
  data = [['Skill', 'Level']];
  for (var skill of app.skills) {
    data.push([skill.name, skill.level]);
  }
  var data = google.visualization.arrayToDataTable(data);

  var options = {
    chartArea: {width: '50%'},
    hAxis: {
      minValue: 0
    },
    legend : 'none',
    chartArea:{left:'10%',top:'5%',width:'90%',height:'80%'},
    colors : ['#1E88E5']
  };

  var chart = new google.visualization.BarChart(document.getElementById('skills'));
  chart.draw(data, options);
}


var app = new Vue({
  el : "#app",
  data : {
    basic_data : {},
    projects : [],
    educations : [],
    skills : [],
    publications : []
  }
})

function startApp() {
  // var currentTime = new Date().getTime();
  // while (currentTime + 2000 >= new Date().getTime()) {}

  var address = {
    "3" : "0xcfc13ef85d5c37c0b54da991289f44450c3f30d6" // Ropsten
  }

  // var current_network = web3.version.network;
  // var contract = web3.eth.contract(abi).at(address[current_network]);

  var contract = web3.eth.contract(abi).at(address["3"]);
  console.log("Contract initialized successfully")

  // Get basic data
  var basic_items = ["name", "address", "email", "tel", "github", "stackexchange"];
  basic_items.map(function(item) {
    contract.getBasicData(item, function(error, data) {
      console.log(item, data);
      app.basic_data[item] = data;
    });
  })

  // Get skills
  contract.getSize("skills", function(error, data) {
    var item_size = data["c"][0];
    range(0, item_size - 1).map(function(item) {
      contract.skills(item, function(error, data) {
        console.log(item, data);
        app.skills.push({"name" : data[0], "level" : data[1]["c"][0]})
        if (item == item_size - 1) { drawSkills(); }
      })
    })
  })

  // Get projects
  contract.getSize("projects", function(error, data) {
    var item_size = data["c"][0];
    for (var i = 0; i < item_size; ++i) {
      contract.projects(i, function(error, data) {
        console.log(data);
        app.projects.push({"name" : data[0], "desc" : data[1], "link" : data[2]})
      })
    }
  })

  // Get educations
  contract.getSize("educations", function(error, data) {
    var item_size = data["c"][0];
    for (var i = 0; i < item_size; ++i) {
      contract.educations(i, function(error, data) {
        console.log(data);
        app.educations.push({
          "name" : data[0],
          "speciality" : data[1],
          "year_start" : data[2]["c"][0],
          "year_finish" : data[3]["c"][0]
        })
      })
    }
  })

  // Get publications
  contract.getSize("publications", function(error, data) {
    var item_size = data["c"][0];
    for (var i = 0; i < item_size; ++i) {
      contract.publications(i, function(error, data) {
        console.log(data);
        app.publications.push({"name" : data[0], "link" : data[1], "language" : data[2]});
      })
    }
  })
}
