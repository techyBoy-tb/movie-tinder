import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:movie_tinder/repositories/userRepository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {

  final UserRepository _userRepository;

  AuthBloc({@required UserRepository userRepository}) : assert(userRepository != null), _userRepository = userRepository;

  @override
  AuthState get initialState => Uninitialised();

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is AppStarted) {
      yield* _mapStartedToState();
    } else if (event is LoggedIn) {
      yield* _mapLoggedInToState();
    } else {
      yield* _mapLoggedOutState();
    }
  }

  Stream<AuthState> _mapStartedToState() async* {
    try {
      final isSignedIn = await _userRepository.isAlreadySignedIn();
      if (isSignedIn) {
        final uid = await _userRepository.getUser();
        final isFirstTime = await _userRepository.isFirstTime(uid);

        if (!isFirstTime) {
          yield AuthenticatedButNotSet(uid);
        } else {
          yield Authenticated(uid);
        }
      } else {
        yield Unauthenticated();
      }
    } catch (_) {
      yield Unauthenticated();
    }
  }

  Stream<AuthState> _mapLoggedInToState() async* {
    final uid = await _userRepository.getUser();
    final isFirstTime = await _userRepository.isFirstTime(uid);
    if (!isFirstTime) {
      yield AuthenticatedButNotSet(uid);
    } else {
      yield Authenticated(uid);
    }
  }

  Stream<AuthState> _mapLoggedOutState() async* {
    yield Unauthenticated();
    _userRepository.signOut();
  }
}
