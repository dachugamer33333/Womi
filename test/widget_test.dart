import 'package:flutter_test/flutter_test.dart';

import 'package:womi/main.dart';

void main() {
  testWidgets('App displays bottom navigation', (WidgetTester tester) async {
    await tester.pumpWidget(const WomiApp());

    expect(find.text('Inicio'), findsWidgets);
    expect(find.text('Actividad'), findsWidgets);
    expect(find.text('Billetera'), findsWidgets);
    expect(find.text('Perfil'), findsWidgets);
  });
}
