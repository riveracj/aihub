import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aihub/main.dart';

void main() {
  testWidgets('AI Hub app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(
      child: AIHubApp(),
    ));

    expect(find.text('AI Hub Community'), findsOneWidget);
  });
}
