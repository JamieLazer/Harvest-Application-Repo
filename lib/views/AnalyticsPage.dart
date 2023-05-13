import 'package:dartfactory/GetPieChartData.dart';
import 'package:dartfactory/LineData.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../Arguments/GardenInfoArguments.dart';
import '../Arguments/GraphArguments.dart';
import '../GetLineGraphDataAll.dart';
import '../PieData.dart';
import '../styles.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

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
      appBar: AppBar(
        //This is the title at the top of the screen
        title: const Text('Analytics Overview', style: welcomePageText,),
        backgroundColor: primaryColour,
      ),
      //The body is filled with the foodList class below
      //gardens has been passed to the UserGardenList to ensure we can use this variable in that widget
      body: Analytics(userID, gardenID, food),
    );
  }
}

class Analytics extends StatefulWidget {
  //We have to initialise the variable
    int userID = 0;
    int gardenID = 0;
    List food = [];

  //Constructor
  Analytics(int passedUserID, int passedGardenID, List passedFood, {super.key}) {
    userID = passedUserID;
    gardenID = passedGardenID;
    food = passedFood;
  }

  @override
  State<Analytics> createState() => _AnalyticsState(userID, gardenID, food);
}

//This class holds data related to the list
class _AnalyticsState extends State<Analytics> {
  //We have to initialise the variable
  int userID = 0;
  int gardenID = 0;
  List food = [];
  List<List<LineData>> _LineChartData = [];
  List<PieData> _PieChartData = [];

  //Constructor
  _AnalyticsState(int passedUserID, int passedGardenID, List passedFood) {
    userID = passedUserID;
    gardenID = passedGardenID;
    food = passedFood;
  }

  @override
  void initState(){
    _LineChartData = GetLineGraphDataAll(food, "SUPERTYPE");
    _PieChartData = GetPieChartData(food, "SUPERTYPE");

    // Enables the selection
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var LegendOverflowMode;
    return Column(
      children: [ 
        const Padding(
          padding: EdgeInsets.only(top: 15), //apply padding to all four sides
          child: Text(""),
        ),
        Flexible(
          flex: 5,
          child: 
            Scaffold(
              body: SfCartesianChart(
                onChartTouchInteractionUp: (ChartTouchInteractionArgs args){
                  //Create the arguments that we will pass to the next page
                  GraphArguments args = GraphArguments(
                    userID, gardenID, food);
                    //Navigate to the pie chart page using a named route.
                    Navigator.pushNamed(context, '/supertypeLineGraphPage', arguments: args);
                },
                legend: Legend(
                  isVisible: false, 
                  // Overflowing legend content will be wraped
                  overflowMode: LegendItemOverflowMode.wrap,
                  position: LegendPosition.bottom,
                ),
                //This allows us to not have to specify how many lines there will be
                series: getLineSeries(_LineChartData),
                primaryXAxis: DateTimeAxis(edgeLabelPlacement: EdgeLabelPlacement.shift),
                primaryYAxis: NumericAxis(labelFormat: '{value}g')
              )
            ),
        ),
        Flexible(
          flex: 5,
          child: 
            Scaffold(
              body: SfCircularChart(
                legend: Legend(
                  isVisible: true,
                  // Overflowing legend content will be wraped
                  overflowMode: LegendItemOverflowMode.wrap,
                  position: LegendPosition.top
                ),
                onChartTouchInteractionUp: (ChartTouchInteractionArgs args){
                  //Create the arguments that we will pass to the next page
                      GraphArguments args = GraphArguments(
                        userID, gardenID, food);
                      //Navigate to the pie chart page using a named route.
                      Navigator.pushNamed(context, '/supertypePieChartPage', arguments: args);
                },
                series: <CircularSeries>[
                  // Render pie chart
                  PieSeries<PieData, String>(
                    dataSource: _PieChartData,
                    xValueMapper: (PieData data, _) => data.name,
                    yValueMapper: (PieData data, _) => data.yield,
                  )
                ]
              )
            ),
        ),      
      ]
      );
  }
  List<LineSeries<LineData, DateTime>> getLineSeries(List _LineChartData) {
    List<LineSeries<LineData, DateTime>> lineSeries = [];
    for (int i = 0; i < _LineChartData.length; i++) {
      lineSeries.add(LineSeries<LineData, DateTime>(
        dataSource: _LineChartData[i],
        xValueMapper: (LineData yield, _) => yield.time,
        yValueMapper: (LineData yield, _) => yield.yield,
        )
      );
    }
    return lineSeries;
}
}