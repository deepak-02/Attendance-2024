part of 'reset_password_bloc.dart';

@immutable
abstract class ResetPasswordState {}

class ResetPasswordInitial extends ResetPasswordState {}

class UserNotFoundState extends ResetPasswordState {}

class EmptyFieldState extends ResetPasswordState {}

class SendOtpLoadingState extends ResetPasswordState {}

class SendOtpSuccessState extends ResetPasswordState {}

class SendOtpErrorState extends ResetPasswordState {
  final String error;

  SendOtpErrorState(this.error);
}

class VerifyOtpLoadingState extends ResetPasswordState {}

class VerifyOtpSuccessState extends ResetPasswordState {}

class VerifyOtpInvalidState extends ResetPasswordState {}

class VerifyOtpErrorState extends ResetPasswordState {
  final String error;

  VerifyOtpErrorState(this.error);
}

class ResetPasswordLoadingState extends ResetPasswordState {}

class ResetPasswordSuccessState extends ResetPasswordState {}

class ResetPasswordErrorState extends ResetPasswordState {
  final String error;

  ResetPasswordErrorState(this.error);
}

class ResetPasswordMissMatchState extends ResetPasswordState {}

class ResetPasswordFormatErrorState extends ResetPasswordState {}
