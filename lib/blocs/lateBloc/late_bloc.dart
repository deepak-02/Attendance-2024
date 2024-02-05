import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../db/api.dart';
import '../../db/late/getlateModel.dart';

part 'late_event.dart';
part 'late_state.dart';

class LateBloc extends Bloc<LateEvent, LateState> {
  String email = 'Choose an email'; // if admin
  LateBloc() : super(LateInitial()) {
    on<UserChangeEvent>((event, emit) {
      email = event.email;
    });

    on<GetAllLateEvent>((event, emit) async {
      try {
        emit(GetAllLateLoadingState());
        final response = await http.post(
          Uri.parse('${api}late/getAll'),
          body: jsonEncode({"status": event.status}),
          headers: {"content-type": "application/json"},
        );

        if (response.statusCode == 200) {
          final data = getLateModelFromJson(response.body);
          emit(GetAllLateSuccessState(lateRequests: data.lateRequests));
        } else if (response.statusCode == 404) {
          emit(GetAllLateNotFoundState());
        } else {
          emit(GetAllLateErrorState(error: response.body));
        }
      } catch (e) {
        print(e);
        emit(GetAllLateErrorState(error: "Something wrong!"));
      }
    });

    on<GetLateByEmailEvent>((event, emit) async {
      try {
        emit(GetLateByEmailLoadingState());

        SharedPreferences prefs = await SharedPreferences.getInstance();
        String email = prefs.getString('email')!;

        final response = await http.post(
          Uri.parse('${api}late/getByEmail'),
          body: jsonEncode({"email": email, "status": event.status}),
          headers: {"content-type": "application/json"},
        );

        if (response.statusCode == 200) {
          final data = getLateModelFromJson(response.body);
          emit(GetLateByEmailSuccessState(lateRequests: data.lateRequests));
        } else if (response.statusCode == 404) {
          emit(GetLateByEmailNotFoundState());
        } else {
          emit(GetLateByEmailErrorState(error: response.body));
        }
      } catch (e) {
        print(e);
        emit(GetLateByEmailErrorState(error: "Something wrong!"));
      }
    });

    on<RequestLateEvent>((event, emit) async {
      try {
        if (event.date.isEmpty || event.date == '') {
          emit(RequestLateDateEmptyState());
          return;
        } else if (event.reason == '' || event.reason.isEmpty) {
          emit(RequestLateReasonEmptyState());
          return;
        } else {
          emit(RequestLateLoadingState());

          SharedPreferences prefs = await SharedPreferences.getInstance();
          String email = prefs.getString('email')!;

          final response = await http.post(
            Uri.parse('${api}late/request'),
            body: jsonEncode({
              "email": email,
              "reason": event.reason,
              "on": event.date, //"1/25/2024",
              "requestMethod": "app"
            }),
            headers: {"content-type": "application/json"},
          );

          if (response.statusCode == 201) {
            emit(RequestLateSuccessState());
          } else {
            emit(RequestLateErrorState(error: response.body));
          }
        }
      } catch (e) {
        print(e);
        emit(RequestLateErrorState(error: "Something wrong!"));
      }
    });

    on<RequestLateAdminEvent>((event, emit) async {
      try {
        if (email == 'Choose an email' || email.isEmpty) {
          emit(RequestLateAdminUserEmptyState());
          return;
        } else if (event.date.isEmpty || event.date == '') {
          emit(RequestLateAdminDateEmptyState());
          return;
        } else if (event.reason == '' || event.reason.isEmpty) {
          emit(RequestLateAdminReasonEmptyState());
          return;
        } else {
          emit(RequestLateAdminLoadingState());

          final response = await http.post(
            Uri.parse('${api}late/request'),
            body: jsonEncode({
              "email": email,
              "reason": event.reason,
              "on": event.date, //"1/25/2024",
              "requestMethod": "call"
            }),
            headers: {"content-type": "application/json"},
          );

          if (response.statusCode == 201) {
            emit(RequestLateAdminSuccessState());
          } else {
            emit(RequestLateAdminErrorState(error: response.body));
          }
        }
      } catch (e) {
        print(e);
        emit(RequestLateAdminErrorState(error: "Something wrong!"));
      }
    });

    on<ChangeLateStatusEvent>((event, emit) async {
      try {
        emit(ChangeLateStatusLoadingState());

        final response = await http.post(
          Uri.parse('${api}late/change'),
          body: jsonEncode({
            "email": event.email,
            "lateId": event.id,
            "status": event.status //approved , rejected
          }),
          headers: {"content-type": "application/json"},
        );

        if (response.statusCode == 200) {
          emit(ChangeLateStatusSuccessState());
        } else if (response.statusCode == 404) {
          emit(ChangeLateStatusNotFoundState());
        } else {
          emit(ChangeLateStatusErrorState(error: response.body));
        }
      } catch (e) {
        print(e);
        emit(ChangeLateStatusErrorState(error: "Something wrong!"));
      }
    });
  }
}
