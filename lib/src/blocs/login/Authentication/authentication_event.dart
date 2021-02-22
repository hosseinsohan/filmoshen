import 'package:meta/meta.dart';

@immutable
abstract class AuthenticationEvent {}

class AppStarted extends AuthenticationEvent {}

class LoggedIn extends AuthenticationEvent {
  final String mobile;
  final String token;

  LoggedIn({@required this.mobile, @required this.token});

  @override
  List<Object> get props => [token];

  @override
  String toString() => 'LoggedIn { token: $token }';
}

class LoggedOut extends AuthenticationEvent {}
