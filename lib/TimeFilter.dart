List TimeFilter(List food, String filter) {

  // If we want the data for the last year
  if (filter == "1y"){
    DateTime end = food[food.length -1]["HARVEST_DATE"];
    // Subtract 1 year from the most recent date
    DateTime start = DateTime(end.year - 1, end.month, end.day);
    for(int i = 0; i < food.length; i++){
      DateTime date = food[i]["HARVEST_DATE"];
      //If the food list item does not match our filter, remove it
      if (date.isBefore(start)){
        food.removeAt(i);
        i--;
      }
    }
  }

  // If we want the data for the last 6 months
  else if (filter == "6m"){
    DateTime end = food[food.length -1]["HARVEST_DATE"];
    // Subtract 6 months from the most recent date
    DateTime start = DateTime(end.year, end.month - 6, end.day);
    for(int i = 0; i < food.length; i++){
      DateTime date = food[i]["HARVEST_DATE"];
      //If the food list item does not match our filter, remove it
      if (date.isBefore(start)){
        food.removeAt(i);
        i--;
      }
    }
  }

  // If we want the data for the last month
  else if (filter == "1m"){
    DateTime end = food[food.length -1]["HARVEST_DATE"];
    // Subtract 1 month from the most recent date
    DateTime start = DateTime(end.year, end.month - 1, end.day);
    for(int i = 0; i < food.length; i++){
      DateTime date = food[i]["HARVEST_DATE"];
      //If the food list item does not match our filter, remove it
      if (date.isBefore(start)){
        food.removeAt(i);
        i--;
      }
    }
  }

  return food;

}