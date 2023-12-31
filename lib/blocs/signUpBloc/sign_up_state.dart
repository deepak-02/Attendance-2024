part of 'sign_up_bloc.dart';

@immutable
abstract class SignUpState {}

class SignUpInitial extends SignUpState {}

class SignUpLoadingState extends SignUpState {}

class SignUpSuccessState extends SignUpState {}

class SignUpFailedState extends SignUpState {
  final String error;

  SignUpFailedState({required this.error});
}

class EmptyFieldsState extends SignUpState {}

class PasswordFormatErrorState extends SignUpState {}

class UserAlreadyExistsState extends SignUpState {}
