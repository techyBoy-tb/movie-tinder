part of 'sign_up_bloc.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object> get props => [];
}

class EmailChanged extends SignUpEvent {
  final String email;
  EmailChanged({@required this.email});

  @override
  List<Object> get props => [email];

  @override
  String toString() => "Email has been changed: {email: $email}";
}

class PasswordChanged extends SignUpEvent {
  final String password;
  PasswordChanged({@required this.password});

  @override
  List<Object> get props => [password];

  @override
  String toString() => "Password has been changed: {password: $password}";
}

class Submitted extends SignUpEvent {
  final String email;
  final String password;

  Submitted({this.email, this.password});

  @override
  List<Object> get props => [email, password];
}

class SignUpWithCredentials extends SignUpEvent {
  final String email;
  final String password;

  SignUpWithCredentials({@required this.email, @required this.password});

  @override
  List<Object> get props => [email, password];
}
