part of 'login_bloc.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class BadCredentialsState extends LoginState {}

class NoUserFoundState extends LoginState {}

class EmptyFieldsState extends LoginState {}

class PasswordFormatErrorState extends LoginState {}

class LoginErrorState extends LoginState {
  final String error;

  LoginErrorState({required this.error});
}

class LoginLoadingState extends LoginState {}

class LoginSuccessState extends LoginState {}
