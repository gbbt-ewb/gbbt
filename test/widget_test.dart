import 'package:flutter_test/flutter_test.dart';
import 'package:gbbt_bank/main.dart';

void main() {
  testWidgets('GBBT Bank smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const GbbtBankApp());
    expect(find.text('GBBT Bank'), findsOneWidget);
  });
}
