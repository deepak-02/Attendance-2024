part of 'attendance_bloc.dart';

@immutable
abstract class AttendanceState {}

class AttendanceInitial extends AttendanceState {}

class GetCurrentAttendanceLoading extends AttendanceState {}

class GetCurrentAttendanceSuccess extends AttendanceState {
  final List<AttendanceElement>? attendance;

  GetCurrentAttendanceSuccess({required this.attendance});
}

class GetCurrentAttendanceEmpty extends AttendanceState {}

class GetCurrentAttendanceError extends AttendanceState {
  final String message;

  GetCurrentAttendanceError({required this.message});
}

class MyAttendanceLoading extends AttendanceState {}

class MyAttendanceSuccess extends AttendanceState {
  final List<Attendance>? attendance;

  MyAttendanceSuccess({required this.attendance});
}

class MyAttendanceEmpty extends AttendanceState {}

class MyAttendanceError extends AttendanceState {
  final String message;

  MyAttendanceError({required this.message});
}
