import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

import '../../db/admin/adminAttendanceModel.dart';
import '../../db/api.dart';

part 'admin_event.dart';
part 'admin_state.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  AdminBloc() : super(AdminInitial()) {
    on<AdminEvent>((event, emit) {

    });

    on<GetAdminAttendanceEvent>((event, emit) async {
      try{
        emit(GetAdminAttendanceLoading());


        final response = await http.post(
          Uri.parse('${api}attendance/getByMonthAndBatch'),
          body: jsonEncode(event.filter),
          headers: {"content-type": "application/json"},
        );

        if (response.statusCode == 200) {
          final result = adminAttendanceModelFromJson(response.body);
          if (result.attendances!.isNotEmpty || result.attendances == []) {
            emit(GetAdminAttendanceSuccess(result.attendances));
          }  else{
            emit(GetAdminAttendanceNotFound());
          }
        }  else if(response.statusCode == 404){
          emit(GetAdminAttendanceNotFound());
        } else{
          emit(GetAdminAttendanceError(response.body));
        }

      }catch(e){
        print(e);
        emit(GetAdminAttendanceError(e.toString()));
      }
    });




  }
}
