import 'package:flutter_test/flutter_test.dart';

import 'package:siraj_app/main.dart';

void main() {
  testWidgets('App renders the bottom navigation bar', (WidgetTester tester) async {
    await tester.pumpWidget(const SirajApp());

    // Verify bottom nav items are present
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Search'), findsOneWidget);
    expect(find.text('Add'), findsOneWidget);
    expect(find.text('Notifications'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });
}
