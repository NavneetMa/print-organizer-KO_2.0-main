import 'package:flutter_test/flutter_test.dart';
import 'package:kwantapo/App.dart';

void main() {
  testWidgets('Test', (WidgetTester tester) async {
    await tester.pumpWidget(App());
  });
}
