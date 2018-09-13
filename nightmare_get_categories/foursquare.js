var fs = require("fs");
var formatCSV = "";

// 配列をcsvで保存するfunction
function exportCSV(content) {
  for (var i = 0; i < content.length; i++) {
    var value = content[i];

    for (var j = 0; j < value.length; j++) {
      var innerValue = value[j] === null ? "" : value[j].toString();
      var result = innerValue.replace(/"/g, '""');
      if (result.search(/("|,|\n)/g) >= 0) result = '"' + result + '"';
      if (j > 0) formatCSV += ",";
      formatCSV += result;
    }
    formatCSV += "\n";
  }
  fs.writeFile("foursquare_id.csv", formatCSV, "utf8", function(err) {
    if (err) {
      console.log("保存できませんでした");
    } else {
      console.log("保存できました");
    }
  });
}

var Nightmare = require("nightmare");
var vo = require("vo");

vo(run)(function(err) {
  console.log("Finished!");
});

function* run() {
  var nightmare = Nightmare({
    show: true, // GUIで動作を確認する
    width: 1024, // 画面サイズ（幅）
    height: 800 // 画面サイズ（高さ）
  });

  yield nightmare
    .goto("https://developer.foursquare.com/docs/resources/categories")
    .wait(
      "#page-content-wrapper > article > div > div > ul > li:nth-child(4) > div"
    )
    .evaluate(() => {
      var items = document
        .querySelector(
          "#page-content-wrapper > article > div > div > ul > li:nth-child(4) > div"
        )
        .getElementsByClassName("categoryItem");
      var restaurants = [
        ["id", "name"],
        ["4d4b7105d754a06374d81259", "飲食店"]
      ];
      for (var i = 0; i < items.length; i++) {
        restaurants.push([
          items[i].getElementsByClassName("categoryId")[0].innerText,
          items[i].getElementsByClassName("categoryName")[0].innerText
        ]);
      }
      return restaurants;
    })
    .then(result => {
      console.log(result);
      exportCSV(result);
    });
}
