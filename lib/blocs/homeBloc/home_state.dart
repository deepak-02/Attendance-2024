part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class FCMTokenLoading extends HomeState {}

class FCMTokenSuccess extends HomeState {}

class FCMTokenError extends HomeState {}

class AttendanceStatusLoading extends HomeState {}

class AttendanceStatusSuccess extends HomeState {
  final String status;

  AttendanceStatusSuccess({required this.status});
}

class AttendanceStatusError extends HomeState {}

class MarkInAttendanceLoading extends HomeState {}

class MarkOutAttendanceLoading extends HomeState {}

class MarkAttendanceSuccess extends HomeState {}

class MarkAttendanceError extends HomeState {}

class MarkAttendanceInvalid extends HomeState {
  final String message;

  MarkAttendanceInvalid({required this.message});
}

class GetProfileImageLoading extends HomeState {}

class GetProfileImageSuccess extends HomeState {
  final image;

  GetProfileImageSuccess({required this.image});
}

class GetProfileImageNotFound extends HomeState {}

class GetProfileImageError extends HomeState {}
