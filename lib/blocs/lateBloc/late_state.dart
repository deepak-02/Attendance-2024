part of 'late_bloc.dart';

@immutable
abstract class LateState {}

class LateInitial extends LateState {}

class RequestLateLoadingState extends LateState {}

class RequestLateSuccessState extends LateState {}

class RequestLateErrorState extends LateState {
  final String error;

  RequestLateErrorState({required this.error});
}

class RequestLateDateEmptyState extends LateState {}

class RequestLateReasonEmptyState extends LateState {}

class RequestLateAdminLoadingState extends LateState {}

class RequestLateAdminSuccessState extends LateState {}

class RequestLateAdminErrorState extends LateState {
  final String error;

  RequestLateAdminErrorState({required this.error});
}

class RequestLateAdminDateEmptyState extends LateState {}

class RequestLateAdminReasonEmptyState extends LateState {}

class RequestLateAdminUserEmptyState extends LateState {}

class GetAllLateLoadingState extends LateState {}

class GetAllLateErrorState extends LateState {
  final String error;

  GetAllLateErrorState({required this.error});
}

class GetAllLateSuccessState extends LateState {
  final List<LateRequest>? lateRequests;

  GetAllLateSuccessState({required this.lateRequests});
}

class GetAllLateNotFoundState extends LateState {}

class GetLateByEmailLoadingState extends LateState {}

class GetLateByEmailSuccessState extends LateState {
  final List<LateRequest>? lateRequests;

  GetLateByEmailSuccessState({required this.lateRequests});
}

class GetLateByEmailErrorState extends LateState {
  final String error;

  GetLateByEmailErrorState({required this.error});
}

class GetLateByEmailNotFoundState extends LateState {}

class ChangeLateStatusLoadingState extends LateState {}

class ChangeLateStatusSuccessState extends LateState {}

class ChangeLateStatusErrorState extends LateState {
  final String error;

  ChangeLateStatusErrorState({required this.error});
}

class ChangeLateStatusNotFoundState extends LateState {}
