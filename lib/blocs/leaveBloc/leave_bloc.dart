import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../db/api.dart';
import '../../db/leave/listLeave.dart';

part 'leave_event.dart';
part 'leave_state.dart';

class LeaveBloc extends Bloc<LeaveEvent, LeaveState> {
  String toDate = '';
  String fromDate = '';
  String type = 'casual';
  String reason = '';
  LeaveBloc() : super(LeaveInitial()) {
    on<LeaveEvent>((event, emit) {});

    on<TypeChangeEvent>((event, emit) {
      type = event.type;
    });
    on<ToDateChangeEvent>((event, emit) {
      toDate = event.toDate;
    });
    on<FromDateChangeEvent>((event, emit) {
      fromDate = event.fromDate;
    });
    on<ReasonChangeEvent>((event, emit) {
      reason = event.reason;
    });

    on<RequestBtnPressEvent>((event, emit) async {
      try {
        emit(RequestLeaveLoadingState());

        if (reason.isEmpty|| reason == '') {
          emit(ReasonEmptyState());
          return;
        } else if (fromDate.isEmpty || fromDate == '') {
          emit(FromDateEmptyState());
          return;
        } else if (toDate.isEmpty || toDate == '') {
          emit(ToDateEmptyState());
          return;
        }


        SharedPreferences prefs = await SharedPreferences.getInstance();
        String email = prefs.getString('email')!;
        final response = await http.post(
          Uri.parse('${api}leave/requestLeave'),
          body: jsonEncode({
            "email": email,
            "reason": reason,
            "requestDate": fromDate,
            "toDate": toDate,
            "type": type
          }),
          headers: {"content-type": "application/json"},
        );

        if (response.statusCode == 201) {
          emit(RequestLeaveSuccessState());
        } else {
          emit(RequestLeaveErrorState(error: response.body));
        }
      } catch (e) {
        print(e);
        emit(RequestLeaveErrorState(error: 'something went wrong!'));
      }
    });

    on<ListLeaveEvent>((event, emit) async {
      try {
        emit(ListLeaveLoadingState());

        SharedPreferences prefs = await SharedPreferences.getInstance();
        String email = prefs.getString('email')!;
        final response = await http.post(
          Uri.parse('${api}leave/getByType'),
          body: jsonEncode({"email": email, "type": event.type}),
          headers: {"content-type": "application/json"},
        );

        if (response.statusCode == 200) {
          final data = listLeaveModelFromJson(response.body);

          emit(ListLeaveSuccessState(leaveRequests: data.leaveRequests ?? []));
        } else if (response.statusCode == 404) {
          emit(ListLeaveNotFoundState());
        } else {
          emit(ListLeaveErrorState(error: response.body));
        }
      } catch (e) {
        print(e);
        emit(ListLeaveErrorState(error: 'something went wrong!'));
      }
    });
  }
}
