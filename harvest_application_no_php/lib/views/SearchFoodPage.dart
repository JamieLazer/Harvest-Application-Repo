import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';

import '../Arguments/GardenInfoArguments.dart';
import '../Arguments/LogFoodArguments.dart';
import '../ConnectionSettings.dart';

class SearchFoodPage extends StatelessWidget {
  const SearchFoodPage({super.key});

  @override
  Widget build(BuildContext context) {
    //Extract the arguments passed to this page as a UserInfoArguments
    final arguments =
    ModalRoute.of(context)!.settings.arguments as GardenInfoArguments;
    //Extract the garden's info from the arguments
    int userID = arguments.userID;
    int gardenID = arguments.gardenID;
    List food = arguments.food;

    //When you push a new screen after a MaterialApp, a back button is automatically added
    return Scaffold(
      //This is the title at the top of the screen
      appBar: AppBar(
        title: const Text('Harvest'),
      ),
      //The body is filled with the AddGardenForm class below
      body: FoodList(userID, gardenID, food),
    );
  }
}

class FoodList extends StatefulWidget {
  //We have to initialise the variable
    int userID = 0;
    int gardenID = 0;
    List food = [];

  //Constructor
  FoodList(int passedUserID, int passedGardenID, List passedFood, {super.key}) {
    this.userID = passedUserID;
    this.gardenID = passedGardenID;
    this.food = passedFood;
  }

  @override
  State<FoodList> createState() => _FoodListState(userID, gardenID, food);
}

class _FoodListState extends State<FoodList> {
  //We have to initialise the variable
    int userID = 0;
    int gardenID = 0;
    List food = [];

  //Constructor
  _FoodListState(int passedUserID, int passedGardenID, List passedFood) {
    this.userID = passedUserID;
    this.gardenID = passedGardenID;
    this.food = passedFood;
  }

  TextEditingController editingController = TextEditingController();

  final duplicateItems = <String>[];
  var items = <String>[];

  @override
  void initState() {
    for(int i = 0; i < food.length; i++){
      //Add every food item in the database to duplicateItems
      duplicateItems.add(food[i]["food_name"]);
    }
    //Sort the list alphabetically
    duplicateItems.sort();
    //Create a copy of duplicateItems
    for(int i = 0; i < duplicateItems.length; i++){
      items.add(duplicateItems[i]);
    }
    super.initState();
  }

  //This method shortens the list of food based on what a user types into the search
  void filterSearchResults(String query) {
    List<String> dummySearchList = <String>[];
    for(int i = 0; i < duplicateItems.length; i++){
      dummySearchList.add(duplicateItems[i]);
    }
    if(query.isNotEmpty) {
      List<String> dummyListData = <String>[];
      query = query.toLowerCase();
      for (var item in dummySearchList) {
        String itemCopy = item.toLowerCase();
        if(itemCopy.startsWith(query)) {
          dummyListData.add(item);
        }
      }
      setState(() {
        items.clear();
        for(int i = 0; i < dummyListData.length; i++){
          items.add(dummyListData[i]);
        }
      });
      return;
    } else {
      setState(() {
        items.clear();
        for(int i = 0; i < duplicateItems.length; i++){
          items.add(duplicateItems[i]);
        }
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                filterSearchResults(value);
              },
              controller: editingController,
              decoration: const InputDecoration(
                            labelText: "Search",
                            hintText: "Search",
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(25.0))
                            )
                          ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(items[index]),
                  //What happens when the food is tapped
                  onTap: () async {
                    var conn = await MySqlConnection.connect(settings);
                    //Make a request for the food in this garden
                    var results = await conn.query(
                        'select * from YIELD where LOG_ID = ?',
                        [gardenID]);
                    //Convert the results of the database query to a list
                    List foodList = results.toList();
                    //Create the arguments that we will pass to the next page
                    LogFoodArguments args = LogFoodArguments(userID, gardenID, foodList, items[index]);
                    //Navigate to the add food screen using a named route.
                    Navigator.pushNamed(context, '/addFoodPage', arguments: args);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

