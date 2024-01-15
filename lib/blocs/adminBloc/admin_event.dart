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

  LeaveStatusChangeEvent({required this.email, required this.id, required this.status});
}
class GetAllUsers extends AdminEvent {
  final String filter;

  GetAllUsers({required this.filter});
}