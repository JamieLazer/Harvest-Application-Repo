import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../Arguments/GardenInfoArguments.dart';
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
        title: const Text('Analytics', style: welcomePageText,),
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
  List _chartData = [];
  TooltipBehavior _tooltipBehavior = TooltipBehavior();

  //Constructor
  _AnalyticsState(int passedUserID, int passedGardenID, List passedFood) {
    userID = passedUserID;
    gardenID = passedGardenID;
    food = passedFood;
  }

  @override
  void initState(){
    _chartData = getChartData();
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var LegendOverflowMode;
    return SafeArea(
      child: Scaffold(
        body: SfCartesianChart(
          title: ChartTitle(text: "Yearly Yield Analysis"),
          tooltipBehavior: _tooltipBehavior, //This enables tooltips in the chart widget
          legend: Legend(
            isVisible: true, 
            // Overflowing legend content will be wraped
                overflowMode: LegendItemOverflowMode.wrap
          ),
          series: <ChartSeries>[
          LineSeries<YieldData, double>(
            name: "Total Yield",
            dataSource: _chartData[0], 
            xValueMapper: (YieldData yield, _) => yield.year, 
            yValueMapper: (YieldData yield, _) => yield.yield,
            enableTooltip: true),
          LineSeries<YieldData, double>(
            name: "Fruit Yield",
            dataSource: _chartData[1], 
            xValueMapper: (YieldData yield, _) => yield.year, 
            yValueMapper: (YieldData yield, _) => yield.yield,
            enableTooltip: true),
          LineSeries<YieldData, double>(
            name: "Vegetable Yield",
            dataSource: _chartData[2], 
            xValueMapper: (YieldData yield, _) => yield.year, 
            yValueMapper: (YieldData yield, _) => yield.yield,
            enableTooltip: true),
          LineSeries<YieldData, double>(
            name: "Flower Yield",
            dataSource: _chartData[3], 
            xValueMapper: (YieldData yield, _) => yield.year, 
            yValueMapper: (YieldData yield, _) => yield.yield,
            enableTooltip: true),
          LineSeries<YieldData, double>(
            name: "Herb Yield",
            dataSource: _chartData[4], 
            xValueMapper: (YieldData yield, _) => yield.year, 
            yValueMapper: (YieldData yield, _) => yield.yield,
            enableTooltip: true),
          ],
          primaryXAxis: NumericAxis(edgeLabelPlacement: EdgeLabelPlacement.shift),
          primaryYAxis: NumericAxis(labelFormat: '{value}g')
        )
      )
      );
  }

  List getChartData() {

    //This will store the data for the graph
    final List chartData = [];
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

      //The four additions below are just for testing. the database did not have enough years
      totalData.add(YieldData(year[i] + 1, totalYield + 22));
      fruitData.add(YieldData(year[i] + 1, fruitYield - 9));
      vegetableData.add(YieldData(year[i] + 1, vegetableYield + 11));
      flowerData.add(YieldData(year[i] + 1, flowerYield + 13));
      herbData.add(YieldData(year[i] + 1, herbYield - 5));

      totalData.add(YieldData(year[i] + 2, totalYield + 53));
      fruitData.add(YieldData(year[i] + 2, fruitYield + 45));
      vegetableData.add(YieldData(year[i] + 2, vegetableYield + 20));
      flowerData.add(YieldData(year[i] + 2, flowerYield + 10));
      herbData.add(YieldData(year[i] + 2, herbYield + 51));

      totalData.add(YieldData(year[i] + 3, totalYield + 35));
      fruitData.add(YieldData(year[i] + 3, fruitYield + 100));
      vegetableData.add(YieldData(year[i] + 3, vegetableYield + 120));
      flowerData.add(YieldData(year[i] + 3, flowerYield + 96));
      herbData.add(YieldData(year[i] + 3, herbYield + 40));

      totalData.add(YieldData(year[i] + 4, totalYield + 153));
      fruitData.add(YieldData(year[i] + 4, fruitYield + 165));
      vegetableData.add(YieldData(year[i] + 4, vegetableYield + 92));
      flowerData.add(YieldData(year[i] + 4, flowerYield + 100));
      herbData.add(YieldData(year[i] + 4, herbYield + 87));

      //Reset counts
      totalYield = 0;
      fruitYield = 0;
      vegetableYield = 0;
      flowerYield = 0;
      herbYield = 0;
    }

    chartData.add(totalData);
    chartData.add(fruitData);
    chartData.add(vegetableData);
    chartData.add(flowerData);
    chartData.add(herbData);

    return chartData;
  }

}

class YieldData{
  YieldData(this.year, this.yield);
  final double year;
  final double yield;
}