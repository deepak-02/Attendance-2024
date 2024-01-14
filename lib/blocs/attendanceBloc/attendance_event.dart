part of 'attendance_bloc.dart';

@immutable
abstract class AttendanceEvent {}

class GetCurrentAttendance extends AttendanceEvent {}

class GetMyAttendance extends AttendanceEvent {
  final String ? email;

  GetMyAttendance(this.email);
}
