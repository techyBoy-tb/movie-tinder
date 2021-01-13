
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:movie_tinder/repositories/userRepository.dart';
import 'package:movie_tinder/bloc/signup/sign_up_state.dart';
import 'package:movie_tinder/ui/validators.dart';
import 'package:rxdart/rxdart.dart';

part 'sign_up_event.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  UserRepository _userRepository;

  SignUpBloc({@required UserRepository userRepository}) : assert(userRepository != null), _userRepository = userRepository;

  @override
  SignUpState get initialState => SignUpState.empty();

  @override
  Stream<SignUpState> transformEvent(
      Stream<SignUpEvent> events,
      Stream<SignUpState> Function(SignUpEvent) next) {
    final nonDebounceSteam = events.where((event) {
      return (event is !EmailChanged || event is !PasswordChanged);
    });

    final debounceStream = events.where((event) {
      return (event is EmailChanged || event is PasswordChanged);
    }).debounceTime(Duration(milliseconds: 3000));

    return super.transformEvents(nonDebounceSteam.mergeWith([debounceStream]), next);
  }

  @override
  Stream<SignUpState> mapEventToState(
      SignUpEvent event
      ) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event.password);
    } else  if (event is SignUpWithCredentials) {
      yield* _mapSignUpWithCredsToState(
          email: event.email,
          password: event.email);
    }
  }

  Stream<SignUpState> _mapEmailChangedToState(String email) async* {
    yield state.update(isEmailValid: Validators.isValidEmail(email));
  }

  Stream<SignUpState> _mapPasswordChangedToState(String password) async* {
    yield state.update(isPasswordValid: Validators.isValidPassword(password));
  }

  Stream<SignUpState> _mapSignUpWithCredsToState({String email, String password}) async* {
    yield SignUpState.loading();
    try {
      await _userRepository.signUpWithEmail(email, password);
      yield SignUpState.success();
    } catch (_) {
      yield SignUpState.failure();
    }
  }
}

