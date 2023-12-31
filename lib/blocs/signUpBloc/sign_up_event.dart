part of 'sign_up_bloc.dart';

abstract class SignUpEvent {}

class NameChangeEvent extends SignUpEvent {
  final String name;

  NameChangeEvent({required this.name});
}

class EmailChangeEvent extends SignUpEvent {
  final String email;

  EmailChangeEvent({required this.email});
}

class PasswordChangeEvent extends SignUpEvent {
  final String password;

  PasswordChangeEvent({required this.password});
}

class PhoneChangeEvent extends SignUpEvent {
  final String phone;

  PhoneChangeEvent({required this.phone});
}

class AddressChangeEvent extends SignUpEvent {
  final String address;

  AddressChangeEvent({required this.address});
}

class BatchChangeEvent extends SignUpEvent {
  final String batch;

  BatchChangeEvent({required this.batch});
}

class DesignationChangeEvent extends SignUpEvent {
  final String designation;

  DesignationChangeEvent({required this.designation});
}

class SignUpBtnClickEvent extends SignUpEvent {}
