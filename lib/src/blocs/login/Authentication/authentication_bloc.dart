import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:filimo/src/resources/repository/user_repository.dart';
import 'package:flutter/material.dart';
import './bloc.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository userRepository;

  AuthenticationBloc({this.userRepository}) : super(AuthenticationUninitialized());

  @override
  AuthenticationState get initialState => AuthenticationUninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      yield AuthenticationLoading();
      print("درخواست");
      try {
        var hasToken = await userRepository.hasToken();
        yield hasToken == null
            ? AuthenticationUnauthenticated()
            : AuthenticationAuthenticated(token: hasToken);
        print("جواب درخواست");
        print('توکن ذخیره شده: $hasToken');
        /*if (hasToken != null) {
          yield AuthenticationAuthenticated();
        } else {
          yield AuthenticationUnauthenticated();
        }*/
      } catch (e) {
        yield AuthenticationLoading();
      }
    } else if (event is LoggedIn) {
      yield AuthenticationLoading();
      await userRepository.persistToken(event.mobile, event.token);
      var hasToken = await userRepository.hasToken();
      yield AuthenticationAuthenticated(token: hasToken);
    } else if (event is LoggedOut) {
      yield AuthenticationLoading();
      await userRepository.deleteToken();
      yield AuthenticationUnauthenticated();
    }
  }
}
