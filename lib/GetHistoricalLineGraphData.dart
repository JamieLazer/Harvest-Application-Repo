import 'YieldData.dart';

List GetHistoricalLineGraphData(List food) {

    //This will store the data for the graph
    final List LineChartData = [];
    final List<YieldData> totalData = [];
    final List<YieldData> fruitData = [];
    final List<YieldData> vegetableData = [];
    final List<YieldData> flowerData = [];
    final List<YieldData> herbData = [];
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

      totalData.add(YieldData(year[i], totalYield));
      fruitData.add(YieldData(year[i], fruitYield));
      vegetableData.add(YieldData(year[i], vegetableYield));
      flowerData.add(YieldData(year[i], flowerYield));
      herbData.add(YieldData(year[i], herbYield));

      //Reset counts
      totalYield = 0;
      fruitYield = 0;
      vegetableYield = 0;
      flowerYield = 0;
      herbYield = 0;
    }

    LineChartData.add(totalData);
    LineChartData.add(fruitData);
    LineChartData.add(vegetableData);
    LineChartData.add(flowerData);
    LineChartData.add(herbData);

    return LineChartData;
  }