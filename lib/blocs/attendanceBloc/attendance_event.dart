part of 'attendance_bloc.dart';

@immutable
abstract class AttendanceEvent {}

class GetCurrentAttendance extends AttendanceEvent {}

class GetMyAttendance extends AttendanceEvent {}
