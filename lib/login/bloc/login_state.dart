import 'package:campus_tool/resources/user_repository.dart';
import 'package:meta/meta.dart';

@immutable
class LoginState {
  final bool isEmailValid;
  final bool isPasswordValid;
  final bool isEmailAuthenticated;
  final bool isEmailVerified;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;
  final bool verificationEmailJustSent;
  final User user;

  bool get isFormValid => isEmailValid && isPasswordValid;

  LoginState({
    @required this.isEmailValid,
    @required this.isPasswordValid,
    @required this.isEmailAuthenticated,
    @required this.isEmailVerified,
    @required this.isSubmitting,
    @required this.isSuccess,
    @required this.isFailure,
    @required this.verificationEmailJustSent,
    @required this.user,
  });

  factory LoginState.empty() {
    return LoginState(
      isEmailValid: true,
      isPasswordValid: true,
      isEmailAuthenticated: false,
      isEmailVerified: false,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
      verificationEmailJustSent: false,
      user: null,
    );
  }

  factory LoginState.loading() {
    return LoginState(
      isEmailValid: true,
      isPasswordValid: true,
      isEmailAuthenticated: false,
      isEmailVerified: false,
      isSubmitting: true,
      isSuccess: false,
      isFailure: false,
      verificationEmailJustSent: false,
      user: null,
    );
  }

  factory LoginState.failure() {
    return LoginState(
      isEmailValid: true,
      isPasswordValid: true,
      isEmailAuthenticated: false,
      isEmailVerified: false,
      isSubmitting: false,
      isSuccess: false,
      isFailure: true,
      verificationEmailJustSent: false,
      user: null,
    );
  }

  factory LoginState.notVerified(User user) {
    return LoginState(
      isEmailValid: true,
      isPasswordValid: true,
      isEmailAuthenticated: true,
      isEmailVerified: false,
      isSubmitting: false,
      isSuccess: false,
      isFailure: true,
      verificationEmailJustSent: false,
      user: user,
    );
  }

  factory LoginState.verificationEmailSent(User user) {
    return LoginState(
      isEmailValid: true,
      isPasswordValid: true,
      isEmailAuthenticated: true,
      isEmailVerified: false,
      isSubmitting: false,
      isSuccess: false,
      isFailure: true,
      verificationEmailJustSent: true,
      user: user,
    );
  }

  factory LoginState.success() {
    return LoginState(
      isEmailValid: true,
      isPasswordValid: true,
      isEmailAuthenticated: true,
      isEmailVerified: true,
      isSubmitting: false,
      isSuccess: true,
      isFailure: false,
      verificationEmailJustSent: true,
      user: null,
    );
  }

  LoginState update({
    bool isEmailValid,
    bool isPasswordValid,
  }) {
    return copyWith(
      isEmailValid: isEmailValid,
      isPasswordValid: isPasswordValid,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
      isEmailAuthenticated: true,
      isEmailVerified: false,
      verificationEmailJustSent: false,
      user: null,
    );
  }

  LoginState copyWith({
    bool isEmailValid,
    bool isPasswordValid,
    bool isSubmitEnabled,
    bool isSubmitting,
    bool isSuccess,
    bool isFailure,
    bool isEmailAuthenticated,
    bool isEmailVerified,
    bool verificationEmailJustSent,
    User user,
  }) {
    return LoginState(
        isEmailValid: isEmailValid ?? this.isEmailValid,
        isPasswordValid: isPasswordValid ?? this.isPasswordValid,
        isSubmitting: isSubmitting ?? this.isSubmitting,
        isSuccess: isSuccess ?? this.isSuccess,
        isFailure: isFailure ?? this.isFailure,
        isEmailAuthenticated: isEmailAuthenticated ?? this.isEmailAuthenticated,
        isEmailVerified: isEmailVerified ?? this.isEmailVerified,
        verificationEmailJustSent:
            verificationEmailJustSent ?? this.verificationEmailJustSent,
        user: user ?? this.user);
  }

  @override
  String toString() {
    return '''LoginState {
      isEmailValid: $isEmailValid,
      isPasswordValid: $isPasswordValid,
      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      isFailure: $isFailure,
      isEmailAuthenticated: $isEmailAuthenticated,
      isEmailVerified: $isEmailVerified,
      verificationEmailJustSent: $verificationEmailJustSent,
      user: $user,
    }''';
  }
}
