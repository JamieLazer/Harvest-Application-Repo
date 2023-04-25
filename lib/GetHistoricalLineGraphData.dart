import 'LineData.dart';

List GetHistoricalLineGraphData(List food) {

    //This will store the data for the graph
    final List LineChartData = [];
    final List<LineData> totalData = [];
    final List<LineData> fruitData = [];
    final List<LineData> vegetableData = [];
    final List<LineData> flowerData = [];
    final List<LineData> herbData = [];
    //This will store the years
    List year = [];
    //This will store the total yield in a specific year
    double totalYield = 0;
    //This will store the yield of each supertype in a specific year
    double fruitYield = 0;
    double vegetableYield = 0;
    double flowerYield = 0;
    double herbYield = 0;

    for(int i = 0; i < food.length; i++){
      //If the list of years does not contain the current year, add it
      if (!year.contains(double.parse(food[i]["HARVEST_DATE"].toString().substring(0,4)))){
        year.add(double.parse(food[i]["HARVEST_DATE"].toString().substring(0,4)));
      }
    }

    //For each year
    for(int i = 0; i < year.length; i++){
      //Loop through the databse results
      for(int j = 0; j < food.length; j++){
        double y = double.parse(food[j]["HARVEST_DATE"].toString().substring(0,4));
        //Add up the yields
        if (food[j]["SUPERTYPE"] == "Fruit" && year[i] == y){
          fruitYield += food[j]["YIELD_KG"];
          totalYield += food[j]["YIELD_KG"];
        }
        else if (food[j]["SUPERTYPE"] == "Vegetable" && year[i] == y){
          vegetableYield += food[j]["YIELD_KG"];
          totalYield += food[j]["YIELD_KG"];
        }
        else if (food[j]["SUPERTYPE"] == "Flower" && year[i] == y){
          flowerYield += food[j]["YIELD_KG"];
          totalYield += food[j]["YIELD_KG"];
        }
        else if (food[j]["SUPERTYPE"] == "Herb" && year[i] == y){
          herbYield += food[j]["YIELD_KG"];
          totalYield += food[j]["YIELD_KG"];
        }
      }

      vegetableData.add(LineData(year[i], vegetableYield, "Vegetable"));
      fruitData.add(LineData(year[i], fruitYield, "Fruit"));
      herbData.add(LineData(year[i], herbYield, "Herb"));
      flowerData.add(LineData(year[i], flowerYield, "Flower"));
      totalData.add(LineData(year[i], totalYield, "Total"));

      //Reset counts
      totalYield = 0;
      fruitYield = 0;
      vegetableYield = 0;
      flowerYield = 0;
      herbYield = 0;
    }

    LineChartData.add(vegetableData);
    LineChartData.add(fruitData);
    LineChartData.add(herbData);
    LineChartData.add(flowerData);
    LineChartData.add(totalData);

    return LineChartData;
  }