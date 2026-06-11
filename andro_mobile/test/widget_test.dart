import 'package:flutter_test/flutter_test.dart';
import 'package:andro_mobile/main.dart';

void main() {
  testWidgets('Andro app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const AndroApp());
    await tester.pump();
  });
}
