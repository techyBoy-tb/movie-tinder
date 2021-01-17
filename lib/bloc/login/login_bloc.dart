import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:movie_tinder/repositories/userRepository.dart';
import 'package:movie_tinder/bloc/login/login_state.dart';
import 'package:movie_tinder/ui/validators.dart';
import 'package:rxdart/rxdart.dart';

part 'login_event.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  UserRepository _userRepository;

  LoginBloc({@required UserRepository userRepository}) : assert(userRepository != null), _userRepository = userRepository;

  @override
  LoginState get initialState => LoginState.empty();

  @override
  Stream<LoginState> transformEvent(
      Stream<LoginEvent> events,
      Stream<LoginState> Function(LoginEvent) next) {
    final nonDebounceSteam = events.where((event) {
      return (event is !EmailChanged || event is !PasswordChanged);
    });

    final debounceStream = events.where((event) {
      return (event is EmailChanged || event is PasswordChanged);
    }).debounceTime(Duration(milliseconds: 3000));

    return super.transformEvents(nonDebounceSteam.mergeWith([debounceStream]), next);
  }

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event
  ) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event.password);
    } else  if (event is LoginWithCredentials) {
      yield* _mapLoginWithCredsToState(
          email: event.email,
          password: event.email);
    }
  }

  Stream<LoginState> _mapEmailChangedToState(String email) async* {
    yield state.update(isEmailValid: Validators.isValidEmail(email));
  }

  Stream<LoginState> _mapPasswordChangedToState(String password) async* {
    yield state.update(isPasswordValid: Validators.isValidPassword(password));
  }

  Stream<LoginState> _mapLoginWithCredsToState({String email, String password}) async* {
    yield LoginState.loading();
    try {
      await _userRepository.signInWithEmail(email, password);
      yield LoginState.success();
    } catch (_) {
      yield LoginState.failure();
    }
  }
}

