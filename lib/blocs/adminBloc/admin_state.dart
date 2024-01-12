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