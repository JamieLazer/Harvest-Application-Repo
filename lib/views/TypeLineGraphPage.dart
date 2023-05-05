import 'package:dartfactory/FilterFoodList.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../Arguments/GraphArguments.dart';
import '../../styles.dart';
import '../GetLineGraphData.dart';
import '../LineData.dart';

class TypeLineGraphPage extends StatelessWidget {
  const TypeLineGraphPage({super.key});

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
      body: TypeLineGraph(userID, gardenID, food, focus),
    );
  }
}

class TypeLineGraph extends StatefulWidget {
  //We have to initialise the variable
    int userID = 0;
    int gardenID = 0;
    List food = [];
    String focus = '';

  //Constructor
  TypeLineGraph(int passedUserID, int passedGardenID, List passedFood, String passedFocus, {super.key}) {
    userID = passedUserID;
    gardenID = passedGardenID;
    food = passedFood;
    focus = passedFocus;
  }

  @override
  State<TypeLineGraph> createState() => _TypeLineGraphState(userID, gardenID, food, focus);
}

//This class holds data related to the list
class _TypeLineGraphState extends State<TypeLineGraph> {
  //We have to initialise the variable
  int userID = 0;
  int gardenID = 0;
  List food = [];
  String focus = '';
  List _LineChartData = [];
  TooltipBehavior _tooltipBehavior = TooltipBehavior();

  //Constructor
  _TypeLineGraphState(int passedUserID, int passedGardenID, List passedFood, String passedFocus) {
    userID = passedUserID;
    gardenID = passedGardenID;
    food = passedFood;
    focus = passedFocus;
  }

  @override
  void initState(){
    //Create a copy of food
    List foodCopy = [...food];
    List foodFiltered = FilterFoodList(foodCopy, "SUPERTYPE", focus);
    _LineChartData = GetLineGraphData(foodFiltered, "TYPE");
    //This enables tooltips in the chart widget
    _tooltipBehavior = TooltipBehavior(enable: true);

    super.initState();
  }

    @override
  Widget build(BuildContext context) {
    return SafeArea(
      child:
        Scaffold(
          body: 
            Scaffold(
              body: SfCartesianChart(
                title: ChartTitle(
                  text: "Yield breakdown by Type", 
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
                series: getLineSeries(_LineChartData),
                primaryXAxis: NumericAxis(edgeLabelPlacement: EdgeLabelPlacement.shift),
                primaryYAxis: NumericAxis(labelFormat: '{value}g')
              )
            ),
        ),    
      );
  }

  List<LineSeries<LineData, num>> getLineSeries(List _LineChartData) {
    List<LineSeries<LineData, num>> lineSeries = [];
    for (int i = 0; i < _LineChartData.length; i++) {
      lineSeries.add(LineSeries<LineData, double>(
        name: _LineChartData[i][0].name,
        dataSource: _LineChartData[i],
        xValueMapper: (LineData yield, _) => yield.year,
        yValueMapper: (LineData yield, _) => yield.yield,
        // When the line is tapped, navigate to the next page
        onPointTap: (ChartPointDetails details){
          String focus = _LineChartData[i][0].name;
          //Create the arguments that we will pass to the next page
          GraphArguments args = GraphArguments(
          userID, gardenID, food, focus);
          //Navigate to the pie chart page using a named route.
          Navigator.pushNamed(context, '/subtypeLineGraphPage', arguments: args);
        },
        )
      );
    }
    return lineSeries;
  }

}