import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:campus_tool/authentication/bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:campus_tool/resources/user_repository.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository _userRep;

  AuthenticationBloc({@required UserRepository userRep})
      : assert(userRep != null),
        _userRep = userRep;

  @override
  AuthenticationState get initialState => Uninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    } else if (event is LoggedIn) {
      yield* _mapLoggedInToState();
    } else if (event is LoggedOut) {
      yield* _mapLoggedOutToState();
    }
  }

  Stream<AuthenticationState> _mapAppStartedToState() async* {
    try {
      final isSignedIn = await _userRep.isSignedIn();
      if (isSignedIn) {
        final name = await _userRep.getUser();
        if (name.user.isEmailVerified)
          yield Authenticated(name.user.email);
        else
          yield Unauthenticated();
      } else {
        yield Unauthenticated();
      }
    } catch (_) {
      yield Unauthenticated();
    }
  }

  Stream<AuthenticationState> _mapLoggedInToState() async* {
    yield Authenticated((await _userRep.getUser()).user.email);
  }

  Stream<AuthenticationState> _mapLoggedOutToState() async* {
    yield Unauthenticated();
    _userRep.signOut();
  }
}
