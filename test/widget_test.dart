// Minimal smoke test so `flutter test` has a green baseline in CI.
//
// The old default counter test was removed: it pumped a counter app that does
// not exist here. Pumping the real MyApp requires Firebase/GetX bootstrapping,
// which is not available in a plain unit-test environment, so this keeps a
// dependency-free sanity check until real widget/unit tests are added.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders a widget', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: Text('sagr'))),
    );

    expect(find.text('sagr'), findsOneWidget);
  });
}
