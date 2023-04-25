import 'package:dartfactory/FilterFoodList.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../Arguments/GraphArguments.dart';
import '../../PieData.dart';
import '../../styles.dart';
import '../../GetPieChartData.dart';

class TypePieChartPage extends StatelessWidget {
  const TypePieChartPage({super.key});

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
        title: const Text('Pie Chart', style: welcomePageText,),
        backgroundColor: primaryColour,
      ),
      //The body is filled with the foodList class below
      //gardens has been passed to the UserGardenList to ensure we can use this variable in that widget
      body: TypePieChart(userID, gardenID, food, focus),
    );
  }
}

class TypePieChart extends StatefulWidget {
  //We have to initialise the variable
    int userID = 0;
    int gardenID = 0;
    List food = [];
    String focus = '';

  //Constructor
  TypePieChart(int passedUserID, int passedGardenID, List passedFood, String passedFocus, {super.key}) {
    userID = passedUserID;
    gardenID = passedGardenID;
    food = passedFood;
    focus = passedFocus;
  }

  @override
  State<TypePieChart> createState() => _TypePieChartState(userID, gardenID, food, focus);
}

//This class holds data related to the list
class _TypePieChartState extends State<TypePieChart> {
  //We have to initialise the variable
  int userID = 0;
  int gardenID = 0;
  List food = [];
  String focus = '';
  List<PieData> _PieChartData = [];

  //Constructor
  _TypePieChartState(int passedUserID, int passedGardenID, List passedFood, String passedFocus) {
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
    _PieChartData = GetPieChartData(foodFiltered, "TYPE");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final rowHeight = ((MediaQuery.of(context).size.height) / 3) / _PieChartData.length;
    double sum=0;
    for(int i=0;i<_PieChartData.length;i++){
      sum+=_PieChartData[i].yield;
    }
    return Column(
      children: [
        Flexible(
          flex: 5,
          child: SfCircularChart(
            legend: Legend(
              isVisible: true,
              // Overflowing legend content will be wraped
              overflowMode: LegendItemOverflowMode.wrap,
              position: LegendPosition.bottom,
              alignment: ChartAlignment.center,
            ),
            title: ChartTitle(
              text: 'Yield breakdown by Type (%)',
              // Aligns the chart title to left
              alignment: ChartAlignment.center,
              textStyle: const TextStyle(
                color: Colors.black,
                decoration: TextDecoration.none,
                fontFamily: 'AbeeZee',
                fontWeight: FontWeight.normal,)
            ),
            series: <CircularSeries>[
              // Render pie chart
              PieSeries<PieData, String>(
                // When the pie segment is tapped, navigate to the next page
                onPointTap: (ChartPointDetails details){
                  String focus = details.dataPoints![details.pointIndex!].x;
                  //Create the arguments that we will pass to the next page
                  GraphArguments args = GraphArguments(
                    userID, gardenID, food, focus);
                  //Navigate to the pie chart page using a named route.
                  Navigator.pushNamed(context, '/subtypePieChartPage', arguments: args);
                },
                dataSource: _PieChartData,
                xValueMapper: (PieData data, _) => data.name,
                yValueMapper: (PieData data, _) => double.parse(((data.yield/sum)*100).toStringAsFixed(2)),
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                  // Positioning the data label
                  labelPosition: ChartDataLabelPosition.inside,
                )
              )
            ]
          )
        ),
        Flexible(
          flex: 5,
          child: DataTable(
            dataRowHeight: rowHeight,
            columns: const [
              DataColumn(label: Text('Type')),
              DataColumn(label: Text('Yield (g)')),
            ],
            rows: List.generate(
              _PieChartData.length, (index) => DataRow(
                cells: <DataCell>[
                  DataCell(Text(_PieChartData[index].name)),
                  DataCell(Text(_PieChartData[index].yield.toString())),
                ],
              )
            ),
          )
        ),
      ]
    ); 
  }

}