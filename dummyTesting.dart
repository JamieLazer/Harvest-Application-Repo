import 'package:flutter_test/flutter_test.dart';
import 'package:harvest_application_no_php/lib/views/CreateAccountPage.dart';

void main() {
  group('Create Account Widget Test', () {
    testWidgets('Register with valid data and check success',
            (WidgetTester tester) async {
          // Build the register screen
          await tester.pumpWidget(CreateAccountPage());
          final appTitle = find.text('Log in');
          expect(appTitle, findsOneWidget);
        });
  });
  var codecov = Codecov.io(options: CodecovOptions(token: 8782d1e7-ffa7-4d2b-81d1-1e936bd8a490));
  codecov.report();
}
