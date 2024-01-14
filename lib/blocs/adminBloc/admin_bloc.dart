import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../db/admin/adminAttendanceModel.dart';
import '../../db/api.dart';
import '../../db/leave/listLeave.dart';

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


    on<GetAdminLeaveRequestsEvent>((event, emit) async {
      try{
        emit(GetAdminLeaveRequestsLoading());

        if (event.type == 'all') {
          final response = await http.get(
            Uri.parse('${api}leave/getAll'),
            headers: {"content-type": "application/json"},
          );

          if (response.statusCode == 200) {
            final data = listLeaveModelFromJson(response.body);

            emit(GetAdminLeaveRequestsSuccess( data.leaveRequests ?? []));
          }else if (response.statusCode == 404){
            emit(GetAdminLeaveRequestsNotFound());
          }else{
            emit(GetAdminLeaveRequestsError(response.body));
          }
        }  else{
          final response = await http.get(
            Uri.parse('${api}leave/getByStatus/${event.type}'),
            headers: {"content-type": "application/json"},
          );

          if (response.statusCode == 200) {
            final data = listLeaveModelFromJson(response.body);

            emit(GetAdminLeaveRequestsSuccess( data.leaveRequests ?? []));
          }else if (response.statusCode == 404){
            emit(GetAdminLeaveRequestsNotFound());
          }else{
            emit(GetAdminLeaveRequestsError(response.body));
          }
        }



      }catch(e){
        print(e);
        emit(GetAdminLeaveRequestsError(e.toString()));
      }
    });


    on<LeaveStatusChangeEvent>((event, emit) async {
      try{
        emit(LeaveStatusChangeLoading());

          final response = await http.post(
            Uri.parse('${api}leave/changeStatus'),
            body : jsonEncode(
              {
                "email": event.email,
                "status": event.status,
                "leaveId": event.id
              }
            ),

            headers: {"content-type": "application/json"},
          );

          if (response.statusCode == 200) {
           emit(LeaveStatusChangeSuccess());
          }else{
            emit(LeaveStatusChangeError(response.body));
          }

      }catch(e){
        print(e);
        emit(LeaveStatusChangeError(e.toString()));
      }
    });


  }
}
