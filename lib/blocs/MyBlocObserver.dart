import 'package:bloc/bloc.dart';


// We can extend `BlocDelegate` and override `onEvent`, `onTransition` and `onError`
// in order to handle events, transitions and errors from all Blocs.
class MyBlocObserver extends BlocObserver {

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    print(event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    print(error);
  }
}