import 'package:dartfactory/FilterFoodList.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../Arguments/GraphArguments.dart';
import '../../styles.dart';
import '../GetLineGraphData1m.dart';
import '../GetLineGraphData1y.dart';
import '../GetLineGraphData6m.dart';
import '../GetLineGraphDataAll.dart';
import '../LineData.dart';
import '../TimeFilter.dart';

class SubtypeLineGraphPage extends StatelessWidget {
  const SubtypeLineGraphPage({super.key});

  @override
  Widget build(BuildContext context) {
    //Extract the arguments passed to this page as a UserInfoArguments
    final arguments =
    ModalRoute.of(context)!.settings.arguments as GraphArguments;
    //Extract the garden's info from the arguments
    int userID = arguments.userID;
    int gardenID = arguments.gardenID;
    List food = arguments.food;
    String focus = arguments.focus!;

    //When you push a new screen after a MaterialApp, a back button is automatically added
    return Scaffold(
      appBar: AppBar(
        //This is the title at the top of the screen
        title: const Text('Line Graph', style: welcomePageText,),
        backgroundColor: primaryColour,
      ),
      //The body is filled with the foodList class below
      //gardens has been passed to the UserGardenList to ensure we can use this variable in that widget
      body: SubtypeLineGraph(userID, gardenID, food, focus),
    );
  }
}

class SubtypeLineGraph extends StatefulWidget {
  //We have to initialise the variable
    int userID = 0;
    int gardenID = 0;
    List food = [];
    String focus = '';

  //Constructor
  SubtypeLineGraph(int passedUserID, int passedGardenID, List passedFood, String passedFocus, {super.key}) {
    userID = passedUserID;
    gardenID = passedGardenID;
    food = passedFood;
    focus = passedFocus;
  }

  @override
  State<SubtypeLineGraph> createState() => _SubtypeLineGraphState(userID, gardenID, food, focus);
}

//This class holds data related to the list
class _SubtypeLineGraphState extends State<SubtypeLineGraph> {
  //We have to initialise the variable
  int userID = 0;
  int gardenID = 0;
  List food = [];
  String focus = '';
  List _LineChartData = [];
  bool _flag1m = true;
  bool _flag6m = true;
  bool _flag1y = true;
  bool _flagAll = false; // This flag must be false so the "All" button is in a different colour

  //Constructor
  _SubtypeLineGraphState(int passedUserID, int passedGardenID, List passedFood, String passedFocus) {
    userID = passedUserID;
    gardenID = passedGardenID;
    food = passedFood;
    focus = passedFocus;
  }

  @override
  void initState(){
    //Create a copy of food
    List foodCopy = [...food];
    List foodFiltered = FilterFoodList(foodCopy, "TYPE", focus);
    _LineChartData = GetLineGraphDataAll(foodFiltered, "SUBTYPE");
    //This enables tooltips in the chart widget

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          flex: 9,
          child: SfCartesianChart(
            title: ChartTitle(
              text: "Yield breakdown by Subype", 
              textStyle: const TextStyle(
              color: Colors.black,
              decoration: TextDecoration.none,
              fontFamily: 'AbeeZee',
              fontWeight: FontWeight.normal,)
            ),
            // tooltipBehavior: _tooltipBehavior, 
            legend: Legend(
              isVisible: true, 
              // Overflowing legend content will be wraped
              overflowMode: LegendItemOverflowMode.wrap,
              position: LegendPosition.bottom,
              // Toogles the series visibility on tapping the legend item
              toggleSeriesVisibility: true
            ),
            series: getLineSeries(_LineChartData),
            primaryXAxis: DateTimeAxis(edgeLabelPlacement: EdgeLabelPlacement.shift),
            primaryYAxis: NumericAxis(labelFormat: '{value}g')
          )
        ),
        Flexible(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                // When the button is pressed, it changes color
                style: ElevatedButton.styleFrom(
                  backgroundColor: _flag1m ? primaryColour : secondaryColour,
                ),
                onPressed: () => setState(() {
                  // Set all the flags of the other buttons to true and the flag of the pressed button to false
                  _flag6m = true;
                  _flag1y = true;
                  _flagAll = true;
                  _flag1m = false;
  
                  //Create a copy of food
                  List foodCopy = [...food];
                  List foodFiltered = FilterFoodList(foodCopy, "TYPE", focus);
                  List foodTimeFiltered = TimeFilter(foodFiltered, "1m");
                  // Clear the line graph data and generate it again using the correct time filter
                  _LineChartData = [];
                  _LineChartData = GetLineGraphData1m(foodTimeFiltered, "SUBTYPE");
                }),  
                child: const Text("1m", style: TextStyle(color: Colors.white)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  // When the button is pressed, it changes color
                  backgroundColor: _flag6m ? primaryColour : secondaryColour,
                ),
                onPressed: () => setState(() {
                  // Set all the flags of the other buttons to true and the flag of the pressed button to false
                  _flag1m = true;
                  _flag1y = true;
                  _flagAll = true;
                  _flag6m = false;

                  //Create a copy of food
                  List foodCopy = [...food];
                  List foodFiltered = FilterFoodList(foodCopy, "TYPE", focus);
                  List foodTimeFiltered = TimeFilter(foodFiltered, "6m");
                  // Clear the line graph data and generate it again using the correct time filter
                  _LineChartData = [];
                  _LineChartData = GetLineGraphData6m(foodTimeFiltered, "SUBTYPE");
                }), 
                child: const Text("6m", style: TextStyle(color: Colors.white)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  // When the button is pressed, it changes color
                  backgroundColor: _flag1y ? primaryColour : secondaryColour,
                ),
                onPressed: () => setState(() {
                  // Set all the flags of the other buttons to true and the flag of the pressed button to false
                  _flag1m = true;
                  _flag6m = true;
                  _flagAll = true;
                  _flag1y = false;

                  //Create a copy of food
                  List foodCopy = [...food];
                  List foodFiltered = FilterFoodList(foodCopy, "TYPE", focus);
                  List foodTimeFiltered = TimeFilter(foodFiltered, "1y");
                  // Clear the line graph data and generate it again using the correct time filter
                  _LineChartData = [];
                  _LineChartData = GetLineGraphData1y(foodTimeFiltered, "SUBTYPE");
                }), 
                child: const Text("1y", style: TextStyle(color: Colors.white)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  // When the button is pressed, it changes color
                  backgroundColor: _flagAll ? primaryColour : secondaryColour,
                ),
                onPressed: () => setState(() {
                  // Set all the flags of the other buttons to true and the flag of the pressed button to false
                  _flag1m = true;
                  _flag6m = true;
                  _flag1y = true;
                  _flagAll = false;

                  //Create a copy of food
                  List foodCopy = [...food];
                  List foodFiltered = FilterFoodList(foodCopy, "TYPE", focus);

                  // Clear the line graph data and generate it again using the correct time filter
                  _LineChartData = [];
                  _LineChartData = GetLineGraphDataAll(foodFiltered, "SUBTYPE");
                }), 
                child: const Text("All", style: TextStyle(color: Colors.white)),
              ),
            ],
          )
        ) 
      ]
    );
  }

  List<LineSeries<LineData, DateTime>> getLineSeries(List _LineChartData) {
    List<LineSeries<LineData, DateTime>> lineSeries = [];
    for (int i = 0; i < _LineChartData.length; i++) {
      lineSeries.add(LineSeries<LineData, DateTime>(
        animationDuration: 0,
        name: _LineChartData[i][0].name,
        dataSource: _LineChartData[i],
        xValueMapper: (LineData yield, _) => yield.time,
        yValueMapper: (LineData yield, _) => yield.yield,
        // When the line is tapped, navigate to the next page
        onPointTap: (ChartPointDetails details){
          String focus = _LineChartData[i][0].name;
          //Create the arguments that we will pass to the next page
          GraphArguments args = GraphArguments(
          userID, gardenID, food, focus);
          //Navigate to the pie chart page using a named route.
          Navigator.pushNamed(context, '/foodLineGraphPage', arguments: args);
        },
        )
      );
    }
    return lineSeries;
  }

}