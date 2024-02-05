import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../db/api.dart';
part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  String name = '';
  String email = '';
  String password = '';
  String phone = '';
  String address = '';
  String batch = '';
  String designation = '';

  SignUpBloc() : super(SignUpInitial()) {
    on<SignUpEvent>((event, emit) {
      print("Signup");
    });

    on<NameChangeEvent>((event, emit) {
      name = event.name;
    });
    on<EmailChangeEvent>((event, emit) {
      email = event.email;
    });
    on<PasswordChangeEvent>((event, emit) {
      password = event.password;
    });
    on<PhoneChangeEvent>((event, emit) {
      phone = event.phone;
    });
    on<AddressChangeEvent>((event, emit) {
      address = event.address;
    });
    on<BatchChangeEvent>((event, emit) {
      batch = event.batch;
    });
    on<DesignationChangeEvent>((event, emit) {
      designation = event.designation;
    });
    on<SignUpBtnClickEvent>((event, emit) async {
      try {
        emit(SignUpLoadingState());

        if (name.isEmpty ||
            email.isEmpty ||
            password.isEmpty ||
            phone.isEmpty ||
            address.isEmpty ||
            batch.isEmpty ||
            designation.isEmpty) {
          emit(EmptyFieldsState());
          return;
        } else if (password.length < 8) {
          emit(PasswordFormatErrorState());
          return;
        } else {
          final response = await http.post(
            Uri.parse('${api}auth/signup'),
            body: jsonEncode({
              "name": name,
              "email": email,
              "password": password,
              "address": address,
              "phoneNumber": phone,
              "batch": batch,
              "designation": designation
            }),
            headers: {"content-type": "application/json"},
          );

          if (response.statusCode == 201) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString("name", name);
            prefs.setString("email", email);
            prefs.setString("batch", batch);
            prefs.setString('role', 'user');

            emit(SignUpSuccessState());
          } else if (response.statusCode == 406) {
            emit(PasswordFormatErrorState());
          } else if (response.statusCode == 409) {
            emit(UserAlreadyExistsState());
          } else {
            emit(SignUpFailedState(error: response.body));
          }
        }
      } catch (e) {
        print(e);
        emit(SignUpFailedState(error: e.toString()));
      }
    });
  }
}
