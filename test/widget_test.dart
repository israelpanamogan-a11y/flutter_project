import 'package:flutter_test/flutter_test.dart';
import 'package:semester_project/app.dart';

void main() {
  testWidgets('Home screen displays Report Form navigation', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Welcome to the Home Screen'), findsOneWidget);
    expect(find.text('Open Report Form'), findsOneWidget);
    expect(find.text('Go to Login'), findsOneWidget);
  });
}
