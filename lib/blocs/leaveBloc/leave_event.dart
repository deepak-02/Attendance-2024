part of 'leave_bloc.dart';

@immutable
abstract class LeaveEvent {}

class ReasonChangeEvent extends LeaveEvent {
  final String reason;

  ReasonChangeEvent({required this.reason});
}

class TypeChangeEvent extends LeaveEvent {
  final String type;

  TypeChangeEvent({required this.type});
}

class FromDateChangeEvent extends LeaveEvent {
  final String fromDate;

  FromDateChangeEvent({required this.fromDate});
}

class ToDateChangeEvent extends LeaveEvent {
  final String toDate;

  ToDateChangeEvent({required this.toDate});
}

class RequestBtnPressEvent extends LeaveEvent {}

class ListLeaveEvent extends LeaveEvent {
  final String type;

  ListLeaveEvent({required this.type});
}
