part of 'reset_password_bloc.dart';

@immutable
abstract class ResetPasswordEvent {}

// class EmailChangeEvent extends ResetPasswordEvent {
//   final String email;
//   EmailChangeEvent({required this.email});
// }

class OTPVerifyEvent extends ResetPasswordEvent {
  final String otp;
  final String email;

  OTPVerifyEvent(this.email, this.otp);
}

class SendOTPEvent extends ResetPasswordEvent {
  final String email;

  SendOTPEvent({required this.email});
}

class PasswordChangeEvent extends ResetPasswordEvent {
  final String password;

  PasswordChangeEvent({required this.password});
}

class ConfirmPasswordChangeEvent extends ResetPasswordEvent {
  final String confirmPassword;

  ConfirmPasswordChangeEvent({required this.confirmPassword});
}

class ResetPasswordBtnClickEvent extends ResetPasswordEvent {}
