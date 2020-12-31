import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AuthenticationEvent extends Equatable {
  AuthenticationEvent([List props = const []]) : super();
}

class AppStarted extends AuthenticationEvent {
  @override
  String toString() => 'AppStarted';

  @override
  // TODO: implement props
  List<Object> get props => ["AppStarted"];
}

class LoggedIn extends AuthenticationEvent {
  @override
  String toString() => 'LoggedIn';

  @override
  // TODO: implement props
  List<Object> get props => ["LoggedIn"];
}

class LoggedOut extends AuthenticationEvent {
  @override
  String toString() => 'LoggedOut';

  @override
  // TODO: implement props
  List<Object> get props => ["LoggedOut"];
}
