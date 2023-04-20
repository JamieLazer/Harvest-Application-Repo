import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../Arguments/GraphArguments.dart';
import '../GetHistoricalLineGraphData.dart';
import '../YieldData.dart';
import '../styles.dart';

class HistoricalLineGraphPage extends StatelessWidget {
  const HistoricalLineGraphPage({super.key});

  @override
  Widget build(BuildContext context) {
    //Extract the arguments passed to this page as a UserInfoArguments
    final arguments =
    ModalRoute.of(context)!.settings.arguments as GraphArguments;
    //Extract the garden's info from the arguments
    int userID = arguments.userID;
    int gardenID = arguments.gardenID;
    List food = arguments.food;

    //When you push a new screen after a MaterialApp, a back button is automatically added
    return Scaffold(
      appBar: AppBar(
        //This is the title at the top of the screen
        title: const Text('Line Graph', style: welcomePageText,),
        backgroundColor: primaryColour,
      ),
      //The body is filled with the foodList class below
      //gardens has been passed to the UserGardenList to ensure we can use this variable in that widget
      body: HistoricalLineGraph(userID, gardenID, food),
    );
  }
}

class HistoricalLineGraph extends StatefulWidget {
  //We have to initialise the variable
    int userID = 0;
    int gardenID = 0;
    List food = [];

  //Constructor
  HistoricalLineGraph(int passedUserID, int passedGardenID, List passedFood, {super.key}) {
    userID = passedUserID;
    gardenID = passedGardenID;
    food = passedFood;
  }

  @override
  State<HistoricalLineGraph> createState() => _HistoricalLineGraphState(userID, gardenID, food);
}

//This class holds data related to the list
class _HistoricalLineGraphState extends State<HistoricalLineGraph> {
  //We have to initialise the variable
  int userID = 0;
  int gardenID = 0;
  List food = [];
  List _LineChartData = [];
  TooltipBehavior _tooltipBehavior = TooltipBehavior();
  SelectionBehavior _selectionBehavior = SelectionBehavior();

  //Constructor
  _HistoricalLineGraphState(int passedUserID, int passedGardenID, List passedFood) {
    userID = passedUserID;
    gardenID = passedGardenID;
    food = passedFood;
  }

  @override
  void initState(){
    _LineChartData = GetHistoricalLineGraphData(food);
    //This enables tooltips in the chart widget
    _tooltipBehavior = TooltipBehavior(enable: true);
    // Enables the selection
    _selectionBehavior = SelectionBehavior(enable: true);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var LegendOverflowMode;
    return SafeArea(
      child:
        Scaffold(
          body: 
            Scaffold(
              body: SfCartesianChart(
                title: ChartTitle(
                  text: "Historical Yield Analysis", 
                  textStyle: const TextStyle(
                    color: Colors.black,
                    decoration: TextDecoration.none,
                    fontFamily: 'AbeeZee',
                    fontWeight: FontWeight.normal,)
                ),
                tooltipBehavior: _tooltipBehavior, 
                legend: Legend(
                  isVisible: true, 
                  // Overflowing legend content will be wraped
                  overflowMode: LegendItemOverflowMode.wrap,
                  position: LegendPosition.bottom,
                  // Toogles the series visibility on tapping the legend item
                  toggleSeriesVisibility: true
                ),
                series: <ChartSeries>[
                  LineSeries<YieldData, double>(
                    name: "Vegetable",
                    dataSource: _LineChartData[2], 
                    xValueMapper: (YieldData yield, _) => yield.year, 
                    yValueMapper: (YieldData yield, _) => yield.yield,
                    enableTooltip: true),
                  LineSeries<YieldData, double>(
                    name: "Fruit",
                    dataSource: _LineChartData[1], 
                    xValueMapper: (YieldData yield, _) => yield.year, 
                    yValueMapper: (YieldData yield, _) => yield.yield,
                    enableTooltip: true),
                  LineSeries<YieldData, double>(
                    name: "Herb",
                    dataSource: _LineChartData[4], 
                    xValueMapper: (YieldData yield, _) => yield.year, 
                    yValueMapper: (YieldData yield, _) => yield.yield,
                    enableTooltip: true),
                  LineSeries<YieldData, double>(
                    name: "Flower",
                    dataSource: _LineChartData[3], 
                    xValueMapper: (YieldData yield, _) => yield.year, 
                    yValueMapper: (YieldData yield, _) => yield.yield,
                    enableTooltip: true),
                  LineSeries<YieldData, double>(
                    name: "Total",
                    dataSource: _LineChartData[0], 
                    xValueMapper: (YieldData yield, _) => yield.year, 
                    yValueMapper: (YieldData yield, _) => yield.yield,
                    enableTooltip: true),
                ],
                primaryXAxis: NumericAxis(edgeLabelPlacement: EdgeLabelPlacement.shift),
                primaryYAxis: NumericAxis(labelFormat: '{value}g')
              )
            ),
        ),    
      );
  }
}