part of 'late_bloc.dart';

@immutable
abstract class LateEvent {}

class RequestLateEvent extends LateEvent {
  final String reason, date;

  RequestLateEvent({required this.reason, required this.date});
}

class RequestLateAdminEvent extends LateEvent {
  final String reason, date;

  RequestLateAdminEvent({required this.reason, required this.date});
}

class GetAllLateEvent extends LateEvent {
  final String status;

  GetAllLateEvent({required this.status});
}

class UserChangeEvent extends LateEvent {
  final String email;

  UserChangeEvent({required this.email});
}

class GetLateByEmailEvent extends LateEvent {
  final String status;

  GetLateByEmailEvent({required this.status});
}

class ChangeLateStatusEvent extends LateEvent {
  final String email, id, status;

  ChangeLateStatusEvent(
      {required this.email, required this.id, required this.status});
}
