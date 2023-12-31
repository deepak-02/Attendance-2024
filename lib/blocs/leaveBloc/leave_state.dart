part of 'leave_bloc.dart';

@immutable
abstract class LeaveState {}

class LeaveInitial extends LeaveState {}

class RequestLeaveLoadingState extends LeaveState {}

class RequestLeaveSuccessState extends LeaveState {}

class RequestLeaveErrorState extends LeaveState {
  final String error;

  RequestLeaveErrorState({required this.error});
}

class ListLeaveLoadingState extends LeaveState {}

class ListLeaveErrorState extends LeaveState {
  final String error;

  ListLeaveErrorState({required this.error});
}

class ListLeaveNotFoundState extends LeaveState {}

class ListLeaveSuccessState extends LeaveState {
  final List<LeaveRequest>? leaveRequests;

  ListLeaveSuccessState({required this.leaveRequests});
}
