import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

import '../../db/admin/adminAttendanceModel.dart';
import '../../db/admin/adminUsersModel.dart';
import '../../db/api.dart';
import '../../db/leave/listLeave.dart';

part 'admin_event.dart';
part 'admin_state.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  String name = '';
  String email = '';
  String password = '';
  String phone = '';
  String address = '';
  String batch = '';
  String designation = '';

  AdminBloc() : super(AdminInitial()) {
    on<AdminEvent>((event, emit) {});

    on<GetAdminAttendanceEvent>((event, emit) async {
      try {
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
          } else {
            emit(GetAdminAttendanceNotFound());
          }
        } else if (response.statusCode == 404) {
          emit(GetAdminAttendanceNotFound());
        } else {
          emit(GetAdminAttendanceError(response.body));
        }
      } catch (e) {
        print(e);
        emit(GetAdminAttendanceError(e.toString()));
      }
    });

    on<GetAdminLeaveRequestsEvent>((event, emit) async {
      try {
        emit(GetAdminLeaveRequestsLoading());

        if (event.type == 'all') {
          final response = await http.get(
            Uri.parse('${api}leave/getAll'),
            headers: {"content-type": "application/json"},
          );

          if (response.statusCode == 200) {
            final data = listLeaveModelFromJson(response.body);

            emit(GetAdminLeaveRequestsSuccess(data.leaveRequests ?? []));
          } else if (response.statusCode == 404) {
            emit(GetAdminLeaveRequestsNotFound());
          } else {
            emit(GetAdminLeaveRequestsError(response.body));
          }
        } else {
          final response = await http.get(
            Uri.parse('${api}leave/getByStatus/${event.type}'),
            headers: {"content-type": "application/json"},
          );

          if (response.statusCode == 200) {
            final data = listLeaveModelFromJson(response.body);

            emit(GetAdminLeaveRequestsSuccess(data.leaveRequests ?? []));
          } else if (response.statusCode == 404) {
            emit(GetAdminLeaveRequestsNotFound());
          } else {
            emit(GetAdminLeaveRequestsError(response.body));
          }
        }
      } catch (e) {
        print(e);
        emit(GetAdminLeaveRequestsError(e.toString()));
      }
    });

    on<LeaveStatusChangeEvent>((event, emit) async {
      try {
        emit(LeaveStatusChangeLoading());

        final response = await http.post(
          Uri.parse('${api}leave/changeStatus'),
          body: jsonEncode({
            "email": event.email,
            "status": event.status,
            "leaveId": event.id
          }),
          headers: {"content-type": "application/json"},
        );

        if (response.statusCode == 200) {
          emit(LeaveStatusChangeSuccess());
        } else {
          emit(LeaveStatusChangeError(response.body));
        }
      } catch (e) {
        print(e);
        emit(LeaveStatusChangeError(e.toString()));
      }
    });

    on<GetAllUsers>((event, emit) async {
      try {
        emit(GetAllUsersLoading());

        final response = await http.get(
          Uri.parse('${api}auth/get-all/${event.filter}'),
          headers: {"content-type": "application/json"},
        );
        if (response.statusCode == 200) {
          final users = adminUsersModelFromJson(response.body);
          emit(GetAllUsersSuccess(users: users));
        } else if (response.statusCode == 404) {
          emit(GetAllUsersNotFound());
        } else {
          emit(GetAllUsersError(response.body));
        }
      } catch (e) {
        print(e);
        emit(GetAllUsersError(e.toString()));
      }
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

    on<AdminSignup>((event, emit) async {
      try {
        emit(AdminSignupLoading());
        if (name.isEmpty ||
            email.isEmpty ||
            password.isEmpty ||
            phone.isEmpty ||
            address.isEmpty ||
            batch.isEmpty ||
            designation.isEmpty) {
          emit(AdminSignupEmpty());
          return;
        } else if (password.length < 8) {
          emit(AdminSignupPasswordFormatError());
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
              "designation": designation,
              "role": "admin"
            }),
            headers: {"content-type": "application/json"},
          );

          if (response.statusCode == 201) {
            emit(AdminSignupSuccess());
          } else if (response.statusCode == 406) {
            emit(AdminSignupPasswordFormatError());
          } else if (response.statusCode == 409) {
            emit(AdminSignupExists());
          } else {
            emit(AdminSignupError());
          }
        }
      } catch (e) {
        print(e);
        emit(AdminSignupError());
      }
    });
  }
}
