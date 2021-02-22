import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:filimo/src/blocs/login/Authentication/bloc.dart';
import 'package:filimo/src/resources/repository/user_repository.dart';
import 'package:flutter/material.dart';
import './bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository userRepository;
  final AuthenticationBloc authenticationBloc;

  LoginBloc({
    @required this.userRepository,
    @required this.authenticationBloc,
  }) : super(LoginInitial());
  @override
  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is LoginButtonPressed) {
      yield LoginLoading();

      try {
        final token = await userRepository.authenticate(
          mobile: event.mobile,
          code: event.code,
        );

        token == "notValid"
            ? LoginFailure(error: "کد ارسالی صحیح نیست")
            : authenticationBloc
                .add(LoggedIn(token: token, mobile: event.mobile));
        yield LoginInitial();
      } catch (error) {
        yield LoginFailure(error: error.toString());
      }
    }
  }
}
