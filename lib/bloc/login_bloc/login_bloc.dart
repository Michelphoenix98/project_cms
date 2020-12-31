import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:campus_tool/bloc/login_bloc/bloc.dart';
import 'package:campus_tool/resources/user_repository.dart';
import 'package:campus_tool/resources/validators.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  UserRepository _userRepository;

  LoginBloc({
    @required UserRepository userRepository,
  })  : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  LoginState get initialState => LoginState.empty();

  @override
  Stream<LoginState> transform(
    Stream<LoginEvent> events,
    Stream<LoginState> Function(LoginEvent event) next,
  ) {
    final observableStream = events as Observable<LoginEvent>;
    final nonDebounceStream = observableStream.where((event) {
      return (event is! EmailChanged && event is! PasswordChanged);
    });
    final debounceStream = observableStream.where((event) {
      return (event is EmailChanged || event is PasswordChanged);
    }).debounce(Duration(milliseconds: 300));
    return super.transform(nonDebounceStream.mergeWith([debounceStream]), next);
  }

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event.password);
    } else if (event is LoginWithGooglePressed) {
      yield* _mapLoginWithGooglePressedToState();
    } else if (event is LoginWithCredentialsPressed) {
      yield* _mapLoginWithCredentialsPressedToState(
        email: event.email,
        password: event.password,
      );
    }
    else if (event is ResendVerificationEmail){
      yield* _mapResendVerificationEmailToState( event.user
      );
    }
  }

  Stream<LoginState> _mapResendVerificationEmailToState(User user) async*{
    _userRepository.sendVerficationLink(user.user);
    LoginState.verificationEmailSent(user);

  }

  Stream<LoginState> _mapEmailChangedToState(String email) async* {
    yield currentState.update(
      isEmailValid: Validators.isValidEmail(email),
    );
  }

  Stream<LoginState> _mapPasswordChangedToState(String password) async* {
    yield currentState.update(
      isPasswordValid: Validators.isValidPassword(password),
    );
  }

  Stream<LoginState> _mapLoginWithGooglePressedToState() async* {
    try {
      //await _userRepository.signInWithGoogle(); implement this later
      yield LoginState.success();
    } catch (_) {
      yield LoginState.failure();
    }
  }

  Stream<LoginState> _mapLoginWithCredentialsPressedToState({
    String email,
    String password,
  }) async* {
    User user;
    yield LoginState.loading();

    user = await _userRepository.signIn(email, password);
    print(user.message);
    if (user.message == "Signed in successfully")
      yield LoginState.success();
    else if (user.message ==
            "There is no user record corresponding to this identifier. The user may have been deleted." ||
        user.message ==
            "The password is invalid or the user does not have a password.") {
      //print("REACHED!");
      yield LoginState.failure();
    } else if (user.message ==
        "Please check your mail for the verification link") {
     // _userRepository.sendVerficationLink(user.user);
      yield LoginState.notVerified(user);
    }
  }
}
