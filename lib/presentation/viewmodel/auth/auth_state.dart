part of 'auth_cubit.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSignUpSuccessful extends AuthState {
  final String message;
  AuthSignUpSuccessful(this.message);
}

class AuthSignInSuccessful extends AuthState {
  final SignInResModel user;
  AuthSignInSuccessful(this.user);
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}
