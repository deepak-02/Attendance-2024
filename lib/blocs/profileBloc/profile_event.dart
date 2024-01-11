part of 'profile_bloc.dart';

@immutable
abstract class ProfileEvent {}

class GetProfileEvent extends ProfileEvent {}

class GetProfileImageEvent extends ProfileEvent {}

class UpdateProfileEvent extends ProfileEvent {}
class LogoutEvent extends ProfileEvent {}

class UploadProfileImageEvent extends ProfileEvent {
  final File image;

  UploadProfileImageEvent(this.image);
}

class RemoveProfileImageEvent extends ProfileEvent {}

class NameChangeEvent extends ProfileEvent {
  final String name;
  NameChangeEvent(this.name);
}

class PhoneChangeEvent extends ProfileEvent {
  final String phone;
  PhoneChangeEvent(this.phone);
}

class AddressChangeEvent extends ProfileEvent {
  final String address;
  AddressChangeEvent(this.address);
}

class BatchChangeEvent extends ProfileEvent {
  final String batch;
  BatchChangeEvent(this.batch);
}

class DesignationChangeEvent extends ProfileEvent {
  final String designation;
  DesignationChangeEvent(this.designation);
}
