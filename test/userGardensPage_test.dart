import 'package:dartfactory/views/UserGardensPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

Future<void> main() async {
  testWidgets("add a garden", (WidgetTester tester) async {

    //Here I pumped the widget directly without having a variable, see navigation test below
    await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Text(
              "You have not added any gardens yet",
              key: Key("noGarden text"),
            ),
          ),
        )
    );
    final textWidget=find.byKey(Key("noGarden text"));
    expect(textWidget, findsOneWidget);
    expect(tester.widget<Text>(textWidget).data, "You have not added any gardens yet");
  });
}

Future<void>main2()async {

 /* late MockUserGardens mockUserGardens;
  setUp(() {
    mockUserGardens=MockUserGardens();
  });*/

  testWidgets("", (WidgetTester tester) async{
    await tester.pumpWidget(UserGardensPage());
    expect(find.text("My Gardens"), findsOneWidget);
  });
  testWidgets("", (WidgetTester tester) async {
    await tester.pumpWidget(UserGardensPage());
    expect(find.byType(ListView() as Type), findsOneWidget);
  });
}

class MockUserGardens extends Mock implements UserGardensPage {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.debug}) {
    // Implementation of the toString method
    return "MockMyClass";
  }
}
