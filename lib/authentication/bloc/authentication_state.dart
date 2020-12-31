import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AuthenticationState extends Equatable {
  AuthenticationState([List props = const []]) : super();
}

class Uninitialized extends AuthenticationState {
  @override
  String toString() => 'Uninitialized';

  @override
  // TODO: implement props
  List<Object> get props => ["Uninitialized"];
}

class Authenticated extends AuthenticationState {
  final String displayName;

  Authenticated(this.displayName) : super([displayName]);

  @override
  String toString() => 'Authenticated { displayName: $displayName }';

  @override
  // TODO: implement props
  List<Object> get props => [displayName];
}

class Unauthenticated extends AuthenticationState {
  @override
  String toString() => 'Unauthenticated';

  @override
  // TODO: implement props
  List<Object> get props => ["Unauthenticated"];
}
