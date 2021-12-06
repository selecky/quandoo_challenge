# quandoo_challenge

I have created this Flutter app as a response to a task that was given to me while applying for a position
as a Flutter Engineer at [Quandoo](https://www.quandoo.de/en), a German restaurant reservation platform.

## Description

- On initialization, the app fetches JSON data from Quandoo's public test API and turns it into
Restaurant Dart objects.
- Main screen is composed of a restaurant cards with main photo and name. These cards are arranged
in list on mobile and grid on tablets.
- On card tapping, the user is sent to a detail screen where all the photos of the restaurant
are available for viewing through swiping. Additionally, restaurant address and rating are displayed.
- On tablets, the layout is divided into master and detail view.

## Technical details

- [BLoC](https://pub.dev/packages/flutter_bloc) architecture is used for navigation.
- Function responsible for API calls is tested using [flutter_test](https://pub.dev/packages/mockito) and [Mockito](https://pub.dev/packages/mockito) packages.
- BLoC and Repository are used to separate UI and business logic.
- The app implements basic widget animation (rating indicator in detail screen) as well as custom
background animation that I have created in [Rive](https://rive.app/).

