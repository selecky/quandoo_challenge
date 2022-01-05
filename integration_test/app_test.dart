
import 'package:quandoo_challenge/customWidgets/myPubCard.dart';
import 'package:quandoo_challenge/screens/detail.dart';
import 'package:quandoo_challenge/main.dart' as app;
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:quandoo_challenge/screens/master.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {

    testWidgets('tapping on a restaurant card opens a screen with details',
            (WidgetTester tester) async {

      app.main();
      await tester.pumpAndSettle();
      // Master widget with restaurant cards is rendered
      expect(find.byType(Master), findsOneWidget);
      // tap on the first restaurant card
      await tester.tap(find.byType(MyPubCard).first);
      await tester.pumpAndSettle();
      // Detail widget with restaurant detail is rendered
      expect(find.byType(Detail), findsOneWidget);
        });

    // TODO - test for tablet view

  });
}