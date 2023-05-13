import 'LineData.dart';

List<List<LineData>> GetLineGraphDataAll(List food, String category) {

    //This will store the years
    List dates = [];
    //This will store the categories we are considering
    List categories = [];

    for(int i = 0; i < food.length; i++){
      DateTime date = DateTime(food[i]["HARVEST_DATE"].year);
      //If the list of years does not contain the current year, add it
      if (!dates.contains(date)){
        dates.add(date);
      }
      //If the list of categories does not contain the current category, add it
      if (!categories.contains(food[i][category])){
        categories.add(food[i][category]);
      }
    }

    // Sort the categories alphabetically
    categories.sort();
    categories.reversed;
    categories = List.from(categories.reversed);

    // //Add a category for the total yield
    // categories.add("Total");

    //This will store the yield of each category in a specific year (initialise all yields to 0)
    List<double> yield = List.filled(categories.length, 0);

    //This will store the line graph data for each category
    List<List<LineData>> data = [];
    for(int i = 0; i < categories.length; i++){
      data.add([]);
    }

    //For each year
    for(int i = 0; i < dates.length; i++){
      //Loop through the databse results
      for(int j = 0; j < food.length; j++){
        DateTime date = DateTime(food[j]["HARVEST_DATE"].year);
        for(int k = 0; k < categories.length; k++){
          //Add up the yields
          if (food[j][category] == categories[k] && dates[i] == date){
            yield[k] += food[j]["YIELD_KG"];
            // yield[categories.length - 1] += food[j]["YIELD_KG"];
          }
        }
      }

      for(int k = 0; k < categories.length; k++){
        data[k].add(LineData(dates[i], yield[k], categories[k]));
      }

      //Reset counts
      yield = List.filled(categories.length, 0);
    }

    return data;
  }