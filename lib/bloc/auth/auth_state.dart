part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class Uninitialised extends AuthState { }

class Authenticated extends AuthState {
  final String userId;

  Authenticated(this.userId);

  @override
  List<Object> get props => [userId];

  @override
  String toString() => "Authenticated user: {userId}";
}

class AuthenticatedButNotSet extends AuthState {
  final String userId;

  AuthenticatedButNotSet(this.userId);

  @override
  List<Object> get props => [userId];

  @override
  String toString() => "Authenticated but not set user: {userId}";
}

class Unauthenticated extends AuthState { }
