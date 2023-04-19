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
  List _LineChartData = [];
  List<PieData> _PieChartData = [];
  TooltipBehavior _tooltipBehavior = TooltipBehavior();
  SelectionBehavior _selectionBehavior = SelectionBehavior();

  //Constructor
  _AnalyticsState(int passedUserID, int passedGardenID, List passedFood) {
    userID = passedUserID;
    gardenID = passedGardenID;
    food = passedFood;
  }

  @override
  void initState(){
    _LineChartData = getChartData()[0];
    _PieChartData = getChartData()[1];

    //This enables tooltips in the chart widget
    _tooltipBehavior = TooltipBehavior(enable: true);
    // Enables the selection
    _selectionBehavior = SelectionBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var LegendOverflowMode;
    return Column(
      children: [ 
        const Padding(
          padding: EdgeInsets.only(top: 15), //apply padding to all four sides
          child: Text("Overview", style: TextStyle(
            fontSize: 20, 
            color: Colors.black,
            decoration: TextDecoration.none,
            fontFamily: 'AbeeZee',
            fontWeight: FontWeight.normal,)),
        ),
        Flexible(
          flex: 5,
          child: 
            Scaffold(
              body: SfCartesianChart(
                //title: ChartTitle(text: "Yearly Yield Analysis"),
                tooltipBehavior: _tooltipBehavior, 
                legend: Legend(
                  isVisible: false, 
                  // Overflowing legend content will be wraped
                  overflowMode: LegendItemOverflowMode.wrap,
                ),
                series: <ChartSeries>[
                  LineSeries<YieldData, double>(
                    name: "Fruit Yield",
                    dataSource: _LineChartData[1], 
                    xValueMapper: (YieldData yield, _) => yield.year, 
                    yValueMapper: (YieldData yield, _) => yield.yield,
                    enableTooltip: true),
                  LineSeries<YieldData, double>(
                    name: "Vegetable Yield",
                    dataSource: _LineChartData[2], 
                    xValueMapper: (YieldData yield, _) => yield.year, 
                    yValueMapper: (YieldData yield, _) => yield.yield,
                    enableTooltip: true),
                  LineSeries<YieldData, double>(
                    name: "Flower Yield",
                    dataSource: _LineChartData[3], 
                    xValueMapper: (YieldData yield, _) => yield.year, 
                    yValueMapper: (YieldData yield, _) => yield.yield,
                    enableTooltip: true),
                  LineSeries<YieldData, double>(
                    name: "Herb Yield",
                    dataSource: _LineChartData[4], 
                    xValueMapper: (YieldData yield, _) => yield.year, 
                    yValueMapper: (YieldData yield, _) => yield.yield,
                    enableTooltip: true),
                  LineSeries<YieldData, double>(
                    name: "Total Yield",
                    dataSource: _LineChartData[0], 
                    xValueMapper: (YieldData yield, _) => yield.year, 
                    yValueMapper: (YieldData yield, _) => yield.yield,
                    enableTooltip: true,
                    selectionBehavior: _selectionBehavior),
                ],
                primaryXAxis: NumericAxis(edgeLabelPlacement: EdgeLabelPlacement.shift),
                primaryYAxis: NumericAxis(labelFormat: '{value}g')
              )
            ),
        ),
        Flexible(
          flex: 5,
          child: 
            Scaffold(
              body: SfCircularChart(
                series: <CircularSeries>[
                  // Render pie chart
                  PieSeries<PieData, String>(
                    dataSource: _PieChartData,
                    xValueMapper: (PieData data, _) => data.name,
                    yValueMapper: (PieData data, _) => data.yield,
                    //which attribute is used for labelling?
                    dataLabelMapper: (PieData data, _) => data.name,
                    dataLabelSettings: const DataLabelSettings(
                      isVisible: true, 
                      labelPosition: ChartDataLabelPosition.outside,
                      // Renders background rectangle and fills it with series color
                      useSeriesColor: true
                    )
                  )
                ]
              )
            ),
        ),      
      ]
      );
  }

  List getChartData() {

    //This will store the data for the graph
    final List LineChartData = [];
    final List<PieData> PieChartData = [
      PieData('Fruit', 0),
      PieData('Vegetable', 0),
      PieData('Herb', 0),
      PieData('Flower', 0)
    ];
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
          PieChartData[0].yield += food[j]["YIELD_KG"];
        }
        else if (food[j]["SUPERTYPE"] == "Vegetable" && year[i] == y){
          vegetableYield += food[j]["YIELD_KG"];
          totalYield += food[j]["YIELD_KG"];
          PieChartData[1].yield += food[j]["YIELD_KG"];
        }
        else if (food[j]["SUPERTYPE"] == "Flower" && year[i] == y){
          flowerYield += food[j]["YIELD_KG"];
          totalYield += food[j]["YIELD_KG"];
          PieChartData[2].yield += food[j]["YIELD_KG"];
        }
        else if (food[j]["SUPERTYPE"] == "Herb" && year[i] == y){
          herbYield += food[j]["YIELD_KG"];
          totalYield += food[j]["YIELD_KG"];
          PieChartData[3].yield += food[j]["YIELD_KG"];
        }
      }

      totalData.add(YieldData(year[i], totalYield));
      fruitData.add(YieldData(year[i], fruitYield));
      vegetableData.add(YieldData(year[i], vegetableYield));
      flowerData.add(YieldData(year[i], flowerYield));
      herbData.add(YieldData(year[i], herbYield));

      //Reset counts
      totalYield = 0;
      fruitYield = 0;
      vegetableYield = 0;
      flowerYield = 0;
      herbYield = 0;
    }

    totalData.sort((a, b) => a.year.compareTo(b.year));
    totalData.sort((a, b) => a.year.compareTo(b.year));
    totalData.sort((a, b) => a.year.compareTo(b.year));
    totalData.sort((a, b) => a.year.compareTo(b.year));

    LineChartData.add(totalData);
    LineChartData.add(fruitData);
    LineChartData.add(vegetableData);
    LineChartData.add(flowerData);
    LineChartData.add(herbData);

    return [LineChartData, PieChartData];
  }

}

class YieldData{
  YieldData(this.year, this.yield);
  final double year;
  final double yield;
}

class PieData {
  PieData(this.name, this.yield);
  String name;
  double yield;

  // Creating the getter method
  double get getYield {
    return yield;
  }
 
  // // Creating the setter method
  // set setName(String name) {
  //   geekName = name;
  // }
}