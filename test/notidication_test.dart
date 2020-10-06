import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iplayground19/bloc/notification.dart';
import 'package:matcher/matcher.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  List<MethodCall> log = [];
  setUp(() {
    log = [];
    MethodChannel channel =
        MethodChannel('plugins.flutter.io/shared_preferences');
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      log.add(methodCall);
      if (methodCall.method == 'getAll') {
        return Map<String, Object>();
      }
      return null;
    });
  });

  blocTest('Test notification bloc', build: () {
    return NotificationBloc(dataBloc: null);
  }, act: (bloc) {
    bloc.add(NotificationBlocLoadEvent());
  }, expect: [
    TypeMatcher<NotificationBlocLoadedState>(),
  ]);

  // test("test notification bloc", () async {
  //   NotificationBloc bloc = NotificationBloc(dataBloc: null);
  //   bloc.add(NotificationBlocLoadEvent());
  //   bloc.add(NotificationBlocAddEvent('123'));
  //   bloc.add(NotificationBlocRemoveEvent('123'));
  //   await expectLater(
  //       bloc.asBroadcastStream(),
  //       emitsInOrder([
  //         TypeMatcher<NotificationBlocLoadedState>(),
  //         TypeMatcher<NotificationBlocLoadedState>(),
  //         TypeMatcher<NotificationBlocLoadedState>(),
  //       ]));
  //   expect(log[0].arguments['value'][0] == '123', isTrue);
  //   expect(log[1].arguments['value'].isEmpty, isTrue);
  //   bloc.close();
  // });

  blocTest('Test notification bloc', build: () {
    return NotificationBloc(dataBloc: null);
  }, act: (bloc) {
    bloc.add(NotificationBlocLoadEvent());
    bloc.add(NotificationBlocAddEvent('123'));
    bloc.add(NotificationBlocRemoveEvent('123'));
  }, expect: [
    TypeMatcher<NotificationBlocLoadedState>(),
    TypeMatcher<NotificationBlocLoadedState>(),
    TypeMatcher<NotificationBlocLoadedState>(),
  ]);
}
