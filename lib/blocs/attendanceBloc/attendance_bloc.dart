import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../db/api.dart';
import '../../db/attendance/currentAttendanceModel.dart';
import '../../db/attendance/myAttendance.dart';

part 'attendance_event.dart';
part 'attendance_state.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  AttendanceBloc() : super(AttendanceInitial()) {
    on<AttendanceEvent>((event, emit) {});

    on<GetCurrentAttendance>((event, emit) async {
      try {
        emit(GetCurrentAttendanceLoading());
        print("getting attendance");
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String batch = prefs.getString('batch')!;

        DateTime now = DateTime.now();
        String formattedDate =
            DateFormat('M/d/yyyy').format(now);

        final response = await http.post(
          Uri.parse('${api}attendance/getByDate'),
          body: jsonEncode({"date": formattedDate, "batch": batch}),
          headers: {"content-type": "application/json"},
        );

        if (response.statusCode == 200) {
          final data = currentAttendanceFromJson(response.body);
          List<AttendanceElement>? attendance = data.attendances;
          if (attendance!.isEmpty) {
            emit(GetCurrentAttendanceEmpty());
          } else if(response.statusCode == 404){
            emit(GetCurrentAttendanceEmpty());
          }else {
            emit(GetCurrentAttendanceSuccess(attendance: attendance));
          }
        } else {
          emit(GetCurrentAttendanceError(message: response.body));
        }
      } catch (e) {
        print(e);
        emit(GetCurrentAttendanceError(message: e.toString()));
      }
    });

    on<GetMyAttendance>((event, emit) async {
      try {
        emit(MyAttendanceLoading());

        SharedPreferences prefs = await SharedPreferences.getInstance();
        String email = prefs.getString('email')!;

        if (event.email == null || event.email == '') {
          final response = await http.get(
            Uri.parse('${api}attendance/get/$email'),
            headers: {"content-type": "application/json"},
          );
          if (response.statusCode == 200) {
            final data = attendanceHistoryFromJson(response.body);
            List<Attendance>? attendance = data.attendances;
            if (attendance!.isEmpty) {
              emit(MyAttendanceEmpty());
            } else {
              emit(MyAttendanceSuccess(attendance: attendance));
            }
          }else if(response.statusCode == 404){
            emit(MyAttendanceEmpty());
          } else {
            emit(MyAttendanceError(message: response.body));
          }
        }  else{
          final response = await http.get(
            Uri.parse('${api}attendance/get/${event.email}'),
            headers: {"content-type": "application/json"},
          );
          if (response.statusCode == 200) {
            final data = attendanceHistoryFromJson(response.body);
            List<Attendance>? attendance = data.attendances;
            if (attendance!.isEmpty) {
              emit(MyAttendanceEmpty());
            } else {
              emit(MyAttendanceSuccess(attendance: attendance));
            }
          }else if(response.statusCode == 404){
            emit(MyAttendanceEmpty());
          } else {
            emit(MyAttendanceError(message: response.body));
          }
        }




      } catch (e) {
        print(e);
        emit(MyAttendanceError(message: e.toString()));
      }
    });
  }
}
