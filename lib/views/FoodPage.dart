import 'package:dartfactory/Arguments/gardenInfoArgumentsv2.dart';
import 'package:dartfactory/Arguments/inviteHelper.dart';
import 'package:dartfactory/styles.dart';
import 'package:mysql1/mysql1.dart';
import 'package:flutter/material.dart';

import '../Arguments/GardenInfoArguments.dart';
import '../ConnectionSettings.dart';

class FoodPage extends StatelessWidget {
  const FoodPage({super.key});

  @override
  Widget build(BuildContext context) {
    //Extract the arguments passed to this page as a UserInfoArguments
    final arguments =
        ModalRoute.of(context)!.settings.arguments as gardenInfoArgs;
    //Extract the garden's info from the arguments
    int userID = arguments.userID;
    int gardenID = arguments.gardenID;
    List food = arguments.food;
    String gardenName = arguments.gardenName;
    List atlas = arguments.atlas;

    //When you push a new screen after a MaterialApp, a back button is automatically added
    return Scaffold(
      appBar: AppBar(
        //This is the title at the top of the screen
        title: const Text(
          'Harvest',
          style: welcomePageText,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            // The back button takes us back to the user gardens page
            Navigator.popUntil(context, ModalRoute.withName('/userGardens'));
          },
        ),
        backgroundColor: primaryColour,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () async {
                    var conn = await MySqlConnection.connect(settings);
                    var results = await conn.query('select * from FOOD');
                    List resultsList = results.toList();
                    gardenInfoArgs args = gardenInfoArgs(
                        userID, gardenID, resultsList, gardenName, atlas);
                    Navigator.pushNamed(context, '/searchFoodPage',
                        arguments: args);
                  },
                  child: const Icon(
                    Icons.add,
                    size: 26.0,
                  ),
                ),
                const SizedBox(
                    width: 8), // Add some spacing between the buttons
                GestureDetector(
                  onTap: () async {
                    var conn = await MySqlConnection.connect(settings);

                    //Make a request for a list of all Users
                    var results = await conn.query(
                        'select user_fname,user_lname,user_email from USERS where user_id not in(?)Order by user_fname,user_lname ASC',
                        [userID]);
                    //Convert the results of the database query to a list
                    List resultsList = results.toList();
                    //Create the arguments that we will pass to the next page
                    InviteHelper args =
                        InviteHelper(userID, gardenName, gardenID, resultsList);
                    //Navigate to the add food screen using a named route.
                    Navigator.pushNamed(context, '/userPage', arguments: args);
                  },
                  child: const Icon(
                    Icons.share,
                    size: 26.0,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      //The body is filled with the foodList class below
      //gardens has been passed to the UserGardenList to ensure we can use this variable in that widget
      body: FoodList(userID, gardenID, food, atlas),
    );
  }
}

class FoodList extends StatefulWidget {
  int userID = 0;
  int gardenID = 0;
  List food = [];
  List atlas = [];

  FoodList(
      int passedUserID, int passedGardenID, List passedFood, List passedAtlas,
      {Key? key}) {
    userID = passedUserID;
    gardenID = passedGardenID;
    food = passedFood;
    atlas = passedAtlas;
  }

  @override
  _FoodListState createState() => _FoodListState(userID, gardenID, food, atlas);
}

class _FoodListState extends State<FoodList> {
  int userID = 0;
  int gardenID = 0;
  List food = [];
  List atlas = [];
  DateTime date = DateTime.now();

  _FoodListState(
      int passedUserID, int passedGardenID, List passedFood, List passedAtlas) {
    userID = passedUserID;
    gardenID = passedGardenID;
    food = passedFood;
    atlas = passedAtlas;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: food.isEmpty
          ? const Center(
              child: Text(
                "You have not added any crops yet",
                style: blackText,
              ),
            )
          : ListView.builder(
              itemCount: food.length,
              itemBuilder: (context, index) {
                if (index == 0 ||
                    food[index]["HARVEST_DATE"].toString().substring(0, 11) !=
                        food[index - 1]["HARVEST_DATE"]
                            .toString()
                            .substring(0, 11)) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 16),
                      Text(
                        food[index]["HARVEST_DATE"].toString().substring(0, 11),
                        style: blackText.copyWith(color: Colors.black54),
                      ),
                      const SizedBox(height: 8),
                      Card(
                        child: ListTile(
                            visualDensity: const VisualDensity(vertical: 4),
                            contentPadding: EdgeInsets.only(left: 16, right: 8),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  food[index]["YIELD_NAME"],
                                  style: secondaryColourText,
                                ),
                                Text(
                                  '${food[index]["YIELD_KG"]} g',
                                  style: secondaryColourText,
                                ),
                              ],
                            ),
                            subtitle: Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '${food[index]["harvested_by"]}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            onTap: () {
                              // Find the tapped food to get atlas information
                              var tapped = atlas.toList().firstWhere(
                                  (element) =>
                                      element["FOOD"].toString() ==
                                      food[index]["YIELD_NAME"]);

                              showModalBottomSheet<void>(
                                context: context,
                                builder: (BuildContext context) {
                                  return SizedBox(
                                    height: 250,
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Column(
                                            children: [
                                              Text(
                                                'Food Information',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Container(
                                                height: 125,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.8, // Set the width to 80% of the screen width,
                                                child: SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: DataTable(columns: [
                                                    DataColumn(
                                                        label: Text("FOOD")),
                                                    DataColumn(
                                                        label: Text("SOW")),
                                                    DataColumn(
                                                        label: Text("PLANT")),
                                                    DataColumn(
                                                        label: Text("HARVEST")),
                                                    DataColumn(
                                                        label: Text("SUN")),
                                                    DataColumn(
                                                        label: Text("pH")),
                                                  ], rows: [
                                                    DataRow(cells: [
                                                      DataCell(Text(
                                                          "${tapped['FOOD']}")),
                                                      DataCell(Text(
                                                          "${tapped['SOW']}")),
                                                      DataCell(Text(
                                                          "${tapped['PLANT']}")),
                                                      DataCell(Text(
                                                          "${tapped['HARVEST']}")),
                                                      DataCell(Text(
                                                          "${tapped['SUN']}")),
                                                      DataCell(Text(
                                                          "${tapped['pH']}"))
                                                    ])
                                                  ]),
                                                ),
                                              ),
                                            ],
                                          ),
                                          ElevatedButton(
                                            child: Text(
                                              'Dismiss',
                                              style: blackText.copyWith(
                                                  color: Colors.white),
                                            ),
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all<
                                                        Color>(
                                              secondaryColour,
                                            )),
                                            onPressed: () =>
                                                Navigator.pop(context),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            }),
                      ),
                    ],
                  );
                } else {
                  return Card(
                    child: ListTile(
                      visualDensity: const VisualDensity(vertical: 4),
                      contentPadding: EdgeInsets.only(left: 16, right: 8),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            food[index]["YIELD_NAME"],
                            style: secondaryColourText,
                          ),
                          Text(
                            '${food[index]["YIELD_KG"]} g',
                            style: secondaryColourText,
                          ),
                        ],
                      ),
                      subtitle: Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '${food[index]["harvested_by"]}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        // Find the tapped food to get atlas information
                        var tapped = atlas.toList().firstWhere((element) =>
                            element["FOOD"].toString() ==
                            food[index]["YIELD_NAME"]);

                        showModalBottomSheet<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return SizedBox(
                              height: 250,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Column(
                                      children: [
                                        Text(
                                          'Food Information',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Container(
                                          height: 125,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.8, // Set the width to 80% of the screen width,
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: DataTable(columns: [
                                              DataColumn(label: Text("FOOD")),
                                              DataColumn(label: Text("SOW")),
                                              DataColumn(label: Text("PLANT")),
                                              DataColumn(
                                                  label: Text("HARVEST")),
                                              DataColumn(label: Text("SUN")),
                                              DataColumn(label: Text("pH")),
                                            ], rows: [
                                              DataRow(cells: [
                                                DataCell(
                                                    Text("${tapped['FOOD']}")),
                                                DataCell(
                                                    Text("${tapped['SOW']}")),
                                                DataCell(
                                                    Text("${tapped['PLANT']}")),
                                                DataCell(Text(
                                                    "${tapped['HARVEST']}")),
                                                DataCell(
                                                    Text("${tapped['SUN']}")),
                                                DataCell(
                                                    Text("${tapped['pH']}"))
                                              ])
                                            ]),
                                          ),
                                        ),
                                      ],
                                    ),
                                    ElevatedButton(
                                      child: Text(
                                        'Dismiss',
                                        style: blackText.copyWith(
                                            color: Colors.white),
                                      ),
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                        secondaryColour,
                                      )),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                }
              },
            ),
    );
  }
}

