part of 'admin_bloc.dart';

@immutable
abstract class AdminEvent {}

class GetAdminAttendanceEvent extends AdminEvent {
  final Map<String, String> filter;

  GetAdminAttendanceEvent({required this.filter});
}