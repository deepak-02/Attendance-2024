import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../db/api.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  String email = '';
  String password = '';

  LoginBloc() : super(LoginInitial()) {
    on<LoginEvent>((event, emit) {});

    on<EmailChangeEvent>((event, emit) {
      email = event.email;
    });

    on<PasswordChangeEvent>((event, emit) {
      password = event.password;
    });

    on<LoginBtnClickEvent>((event, emit) async {
      try {
        emit(LoginLoadingState());
        if (email == '' ||
            email.isEmpty ||
            password == '' ||
            password.isEmpty) {
          emit(EmptyFieldsState());
          return;
        } else if (password.length < 8) {
          emit(PasswordFormatErrorState());
          return;
        } else {
          final response = await http.post(
            Uri.parse('${api}auth/login'),
            body: jsonEncode({
              "email": email,
              "password": password,
            }),
            headers: {"content-type": "application/json"},
          );
          if (response.statusCode == 200) {
            // Login Success
            Map<String, dynamic> responseData = json.decode(response.body);

            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString("name", responseData['name']);
            prefs.setString("email", email);
            prefs.setString("batch", responseData['batch']);

            emit(LoginSuccessState());
          } else if (response.statusCode == 204) {
            emit(NoUserFoundState());
          } else if (response.statusCode == 401) {
            emit(BadCredentialsState());
          } else {
            emit(LoginErrorState(error: response.body));
          }
        }
      } catch (e) {
        print(e);
        emit(LoginErrorState(error: e.toString()));
      }
    });
  }
}
