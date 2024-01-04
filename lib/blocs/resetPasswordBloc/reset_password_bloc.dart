import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../db/api.dart';

part 'reset_password_event.dart';
part 'reset_password_state.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  String password = '';
  String confirmPassword = '';
  String email = '';
  ResetPasswordBloc() : super(ResetPasswordInitial()) {
    on<ResetPasswordEvent>((event, emit) {});

    on<SendOTPEvent>((event, emit) async {
      try {
        emit(SendOtpLoadingState());
        if (event.email.isEmpty) {
          emit(EmptyFieldState());
          return;
        }
        email = event.email;

        final response = await http.post(
          Uri.parse('${api}user/get-otp'),
          body: jsonEncode({
            "email": email,
          }),
          headers: {"content-type": "application/json"},
        );
        if (response.statusCode == 200) {
          emit(SendOtpSuccessState());
        } else if (response.statusCode == 404) {
          emit(UserNotFoundState());
        } else {
          emit(SendOtpErrorState(response.body));
        }
      } catch (e) {
        emit(SendOtpErrorState("Something went wrong!"));
      }
    });

    on<OTPVerifyEvent>((event, emit) async {
      try {
        emit(VerifyOtpLoadingState());
        if (event.otp.isEmpty) {
          emit(EmptyFieldState());
          return;
        }

        final response = await http.post(
          Uri.parse('${api}user/verify-otp'),
          body: jsonEncode({"email": event.email, "otp": event.otp}),
          headers: {"content-type": "application/json"},
        );
        if (response.statusCode == 200) {
          emit(VerifyOtpSuccessState());
        } else if (response.statusCode == 202) {
          emit(VerifyOtpInvalidState());
        } else {
          emit(VerifyOtpErrorState(response.body));
        }
      } catch (e) {
        emit(VerifyOtpErrorState("Something went wrong!"));
      }
    });

    on<PasswordChangeEvent>((event, emit) {
      password = event.password;
    });

    on<ConfirmPasswordChangeEvent>((event, emit) {
      confirmPassword = event.confirmPassword;
    });

    on<ResetPasswordBtnClickEvent>((event, emit) async {
      try {
        emit(ResetPasswordLoadingState());
        if (password.length < 8) {
          emit(ResetPasswordFormatErrorState());
          return;
        }

        if (password == confirmPassword) {
          String mail = '';

          if (email == '' || email.isEmpty) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            mail = prefs.getString('email')!;
          } else {
            mail = email;
          }

          final response = await http.post(
            Uri.parse('${api}user/reset-password'),
            body: jsonEncode({"email": mail, "password": password}),
            headers: {"content-type": "application/json"},
          );
          if (response.statusCode == 200) {
            emit(ResetPasswordSuccessState());
          } else {
            emit(ResetPasswordErrorState(response.body));
          }
        } else {
          emit(ResetPasswordMissMatchState());
        }
      } catch (e) {
        emit(ResetPasswordErrorState("Something went wrong!"));
      }
    });
  }
}
