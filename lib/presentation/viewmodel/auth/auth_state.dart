part of 'auth_cubit.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSignUpSuccessful extends AuthState {}

class AuthSignInSuccessful extends AuthState {}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}
