part of 'admin_bloc.dart';

@immutable
abstract class AdminEvent {}

class GetAdminAttendanceEvent extends AdminEvent {
  final Map<String, String> filter;

  GetAdminAttendanceEvent({required this.filter});
}

class GetAdminLeaveRequestsEvent extends AdminEvent {
  final String type;

  GetAdminLeaveRequestsEvent({required this.type});
}

class LeaveStatusChangeEvent extends AdminEvent {
  final String status;
  final String email;
  final String id;

  LeaveStatusChangeEvent(
      {required this.email, required this.id, required this.status});
}

class GetAllUsers extends AdminEvent {
  final String filter;

  GetAllUsers({required this.filter});
}

class NameChangeEvent extends AdminEvent {
  final String name;

  NameChangeEvent({required this.name});
}

class EmailChangeEvent extends AdminEvent {
  final String email;

  EmailChangeEvent({required this.email});
}

class PasswordChangeEvent extends AdminEvent {
  final String password;

  PasswordChangeEvent({required this.password});
}

class PhoneChangeEvent extends AdminEvent {
  final String phone;

  PhoneChangeEvent({required this.phone});
}

class AddressChangeEvent extends AdminEvent {
  final String address;

  AddressChangeEvent({required this.address});
}

class BatchChangeEvent extends AdminEvent {
  final String batch;

  BatchChangeEvent({required this.batch});
}

class DesignationChangeEvent extends AdminEvent {
  final String designation;

  DesignationChangeEvent({required this.designation});
}

class AdminSignup extends AdminEvent {}
