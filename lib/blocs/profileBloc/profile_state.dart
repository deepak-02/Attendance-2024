part of 'profile_bloc.dart';

@immutable
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class GetProfileLoadingState extends ProfileState {}

class GetProfileSuccessState extends ProfileState {
  final User? user;

  GetProfileSuccessState({required this.user});
}

class GetProfileErrorState extends ProfileState {
  final String error;

  GetProfileErrorState({required this.error});
}

class GetProfileImageLoadingState extends ProfileState {}

class GetProfileImageSuccessState extends ProfileState {
  final String image;

  GetProfileImageSuccessState({required this.image});
}

class GetProfileImageNotFoundState extends ProfileState {}

class GetProfileImageErrorState extends ProfileState {
  final String error;

  GetProfileImageErrorState({required this.error});
}

class LogoutLoadingState extends ProfileState {}

class LogoutSuccessState extends ProfileState {}

class LogoutErrorState extends ProfileState {}

class UpdateProfileLoadingState extends ProfileState {}

class UpdateProfileSuccessState extends ProfileState {}

class UpdateProfileErrorState extends ProfileState {
  final String error;

  UpdateProfileErrorState({required this.error});
}

class UploadProfileImageLoadingState extends ProfileState {}

class UploadProfileImageSuccessState extends ProfileState {}

class UploadProfileImageErrorState extends ProfileState {
  final String error;

  UploadProfileImageErrorState({required this.error});
}

class RemoveProfileImageLoadingState extends ProfileState {}

class RemoveProfileImageSuccessState extends ProfileState {}

class RemoveProfileImageErrorState extends ProfileState {
  final String error;

  RemoveProfileImageErrorState({required this.error});
}

class EmptyFieldsState extends ProfileState {}
