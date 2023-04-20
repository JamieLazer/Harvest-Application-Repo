List FilterFoodList(List food, String category, String filter) {

  for(int i = 0; i < food.length; i++){
      //If the food list item does not match our filter, remove it
      if (food[i][category] != filter){
        food.removeAt(i);
        i--;
      }
    }

    return food;
  }