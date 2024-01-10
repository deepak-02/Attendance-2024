part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class GetAttendanceStatus extends HomeEvent {}
class UploadFCMToken extends HomeEvent {}

class GetProfileImage extends HomeEvent {}

class MarkAttendance extends HomeEvent {
  final String qrCode;
  final String lastScan;

  MarkAttendance({required this.qrCode, required this.lastScan});
}
