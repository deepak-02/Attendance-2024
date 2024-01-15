part of 'admin_bloc.dart';

@immutable
abstract class AdminState {}

class AdminInitial extends AdminState {}

class GetAdminAttendanceLoading extends AdminState {}
class GetAdminAttendanceNotFound extends AdminState {}
class GetAdminAttendanceSuccess extends AdminState {
  final List<Attendance>? attendances;

  GetAdminAttendanceSuccess(this.attendances);
}
class GetAdminAttendanceError extends AdminState {
  final String error;

  GetAdminAttendanceError(this.error);
}


class GetAdminLeaveRequestsLoading extends AdminState {}
class GetAdminLeaveRequestsNotFound extends AdminState {}
class GetAdminLeaveRequestsSuccess extends AdminState {
  final List<LeaveRequest>? leaveRequests;

  GetAdminLeaveRequestsSuccess(this.leaveRequests);
}
class GetAdminLeaveRequestsError extends AdminState {
  final String error;

  GetAdminLeaveRequestsError(this.error);
}
class LeaveStatusChangeLoading extends AdminState {}
class LeaveStatusChangeSuccess extends AdminState {}
class LeaveStatusChangeError extends AdminState {
  final String error;

  LeaveStatusChangeError(this.error);
}

class GetAllUsersLoading extends AdminState {}
class GetAllUsersSuccess extends AdminState {
  final List<AdminUsersModel> users;

  GetAllUsersSuccess({required this.users});
}
class GetAllUsersNotFound extends AdminState {}
class GetAllUsersError extends AdminState {
  final String error;

  GetAllUsersError(this.error);
}