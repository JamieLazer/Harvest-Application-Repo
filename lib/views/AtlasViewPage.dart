import 'package:flutter/material.dart';

import '../styles.dart';

class AtlasViewPage extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    final arguments=ModalRoute.of(context)!.settings.arguments as List;
     List atlas=arguments;

     return Scaffold(
        appBar: AppBar(
          title: Text("Food Atlas"),titleTextStyle: welcomePageText,
          backgroundColor: primaryColour,
        ),
        body: Columns2(atlas),
     );
  }


}


class Columns2 extends StatelessWidget {
  final List atlas;

  Columns2(this.atlas);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: atlas.length,
      itemBuilder: (context, index) {
        // Determine the background color based on the index
        final backgroundColor =
        index % 2 == 0 ? Colors.grey[200] : Colors.white;

        return Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(color: Colors.grey),
          ),
          child: ListTile(
            title: Text(atlas[index]["FOOD"].toString(), style: TextStyle(fontSize: 18,color: secondaryColour),),
            horizontalTitleGap: 2,
            subtitle: Text(
              "Sow: ${atlas[index]["SOW"]}, Plant: ${atlas[index]["PLANT"]}, Harvest: ${atlas[index]["HARVEST"]}, Sun: ${atlas[index]["SUN"]}, pH: ${atlas[index]["pH"]}",
            style: TextStyle(fontSize: 14,color: secondaryColour),),
          ),
        );
      },
    );
  }
}
