import 'PieData.dart';

List<PieData> GetPieChartData(List food, String category) {

    //This will store the data for the graph
    final List<PieData> PieChartData = [];

    List categories = [];

    for(int i = 0; i < food.length; i++){
      //If the list of types does not contain the current type, add it
      if (!categories.contains(food[i][category])){
        categories.add(food[i][category]);
        PieChartData.add(PieData(food[i][category], 0));
      }
    }

    //For each type
    for(int i = 0; i < categories.length; i++){
      //Loop through the databse results
      for(int j = 0; j < food.length; j++){
        //Add up the yields
        if (food[j][category] == categories[i]){
          PieChartData[i].yield += food[j]["YIELD_KG"];
        }
      }
    }

    //Round the data
    for(int i = 0; i < PieChartData.length; i++){
      String inString = PieChartData[i].yield.toStringAsFixed(2); 
      PieChartData[i].yield = double.parse(inString);
    }

    return PieChartData;
  }