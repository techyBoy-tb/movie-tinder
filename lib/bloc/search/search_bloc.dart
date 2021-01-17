import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:movie_tinder/models/user.dart';
import 'package:movie_tinder/repositories/searchRepository.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepository _searchRepository;


  SearchBloc({@required searchRepository}) : assert (searchRepository != null), _searchRepository = searchRepository;

  @override
  SearchState get initialState => InitialSearchState();

  @override
  Stream<SearchState> mapEventToState(
    SearchEvent event,
  ) async* {
    if (event is SelectUserEvent) {
      yield* _mapSelectUserToState(
          currentUserId: event.currentUserId,
          selectedUserId: event.selectedUserId,
          name: event.selectedName,
          photoUrl: event.photoUrl
      );
    }
    if (event is PassUserEvent) {
      yield* _mapPassUserToState(
          currentUserId: event.currentUserId,
          passUserId: event.passUserId,
      );
    }

    if (event is LoadUserEvent) {
      yield* _mapLoadUserToState(userId: event.userId);
    }
  }

  Stream<SearchState> _mapSelectUserToState({
      String currentUserId,
      String selectedUserId,
      String name,
      String photoUrl}) async* {
    yield LoadingState();

    User user = await _searchRepository.chooseUser(currentUserId, selectedUserId, name, photoUrl);
    User currentUser = await _searchRepository.getUserInfo(currentUserId);

    yield LoadUserState(user, currentUser);
  }

  Stream<SearchState> _mapPassUserToState({
    String currentUserId,
    String passUserId}) async* {
    yield LoadingState();

    User user = await _searchRepository.passUser(currentUserId, passUserId);
    User currentUser = await _searchRepository.getUserInfo(currentUserId);

    yield LoadUserState(user, currentUser);
  }

  Stream<SearchState> _mapLoadUserToState({String userId}) async* {
    yield LoadingState();

    User user = await _searchRepository.getUser(userId);
    User currentUser = await _searchRepository.getUserInfo(userId);

    yield LoadUserState(user, currentUser);
  }
}

