import 'package:meta/meta.dart';

@immutable
abstract class LoginEvent {}

class LoginButtonPressed extends LoginEvent {
  final String mobile;
  final String code;

  LoginButtonPressed({
    @required this.mobile,
    @required this.code,
  });
}
