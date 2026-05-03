import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:womi/shared/widgets/womi_bottom_nav.dart';

// Smoke test: verifies the bottom nav widget renders without needing Hive.
void main() {
  testWidgets('WomiBottomNav renders all tabs', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          bottomNavigationBar: WomiBottomNav(
            currentIndex: 0,
            onTap: (_) {},
          ),
        ),
      ),
    );

    expect(find.text('Inicio'), findsWidgets);
    expect(find.text('Actividad'), findsWidgets);
    expect(find.text('Billetera'), findsWidgets);
    expect(find.text('Perfil'), findsWidgets);
  });
}
