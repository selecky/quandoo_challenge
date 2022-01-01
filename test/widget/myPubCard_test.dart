
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quandoo_challenge/customWidgets/Pub.dart';
import 'package:quandoo_challenge/customWidgets/myPubCard.dart';
import 'package:quandoo_challenge/repository/repository.dart';

void main() {

  testWidgets('test MyPubCard widget', (WidgetTester tester) async {

    int numOfTaps = 0;

    final Pub testPub =
    Pub(
        name: 'name',
        location: Location(address: Address(
            street: 'street',
            number: 'number',
            zipcode: 'zipcode',
            city: 'city',
            country: 'country',
            district: 'district')),
        reviewScore: 'reviewScore',
        images: []
    );

    await tester.pumpWidget(
      //MyPubCard widget is wrapped with MaterialApp and Scaffold in order to provide Material widget ancestor
        MaterialApp(
            home: Scaffold(body: MyPubCard(pub: testPub, onTap: () {print(numOfTaps++);}))));

    // Verify that myPubCard is rendered.
    expect(find.byType(MyPubCard), findsOneWidget);

    //finds only name Text
    expect(find.text('name'), findsOneWidget);
    expect(find.text('street'), findsNothing);

    //finds icon instead of pub photo because Pub injected into MyPubCard has no images
    expect(find.byIcon(Icons.deck_rounded), findsOneWidget);
    expect(find.byType(Image), findsNothing);

    //test onTap functionality
    await tester.tap(find.byType(MyPubCard));
    expect(numOfTaps, 1);

  });
}
