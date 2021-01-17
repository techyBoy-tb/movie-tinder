import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:movie_tinder/bloc/profile/profile_state.dart';
import 'package:movie_tinder/repositories/userRepository.dart';
part 'profile_event.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  UserRepository _userRepository;

  ProfileBloc({@required UserRepository userRepository}) : assert (userRepository != null), _userRepository = userRepository;
  @override
  // TODO: implement initialState
  get initialState => ProfileState.empty();

  @override
  Stream<ProfileState> mapEventToState(
    ProfileEvent event,
  ) async* {
    if (event is NameChanged) {
      yield* _mapNameChangedToState(event.name);
    } else if (event is AgeChanged) {
      yield* _mapAgeChangedToState(event.age);
    } else if (event is GenderChanged) {
      yield* _mapGenderChangedToState(event.gender);
    } else if (event is PhotoChanged) {
      yield* _mapPhotoChangedToState(event.photo);
    } else if (event is LocationChanged) {
      yield* _mapLocationChangedToState(event.location);
    } else if (event is InterestedInChanged) {
      yield* _mapInterestedInChangedToState(event.interestedIn);
    } else if (event is Submitted) {
      final uid = await _userRepository.getUser();
      yield* _mapSubmittedToState(
          name: event.name,
          userId: uid,
          gender: event.gender,
          interestedIn: event.interestedIn,
          age: event.age,
          location: event.location,
          photo: event.photo);
    }
  }

  Stream<ProfileState> _mapNameChangedToState(String name) async* {
    yield state.update(
      isNameEmpty: name == null,
    );
  }

  Stream<ProfileState> _mapGenderChangedToState(String gender) async* {
    yield state.update(
      isGenderEmpty: gender == null,
    );
  }

  Stream<ProfileState> _mapInterestedInChangedToState(String interestedIn) async* {
    yield state.update(
      isInterestedInEmpty: interestedIn == null,
    );
  }

  Stream<ProfileState> _mapAgeChangedToState(DateTime age) async* {
    yield state.update(
      isAgeEmpty: age == null,
    );
  }

  Stream<ProfileState> _mapPhotoChangedToState(File photo) async* {
    yield state.update(
      isPhotoEmpty: photo == null,
    );
  }

  Stream<ProfileState> _mapLocationChangedToState(GeoPoint location) async* {
    yield state.update(
      isLocationEmpty: location == null,
    );
  }

  Stream<ProfileState> _mapSubmittedToState({
    File photo,
    String userId,
    String name,
    String gender,
    String interestedIn,
    DateTime age,
    GeoPoint location
  }) async* {
    yield ProfileState.loading();
    try {
      await _userRepository.profileSetup(photo, userId, name, gender, interestedIn, age, location);
      yield ProfileState.success();
    } catch (_) {
      yield ProfileState.failure();
    }
  }
}
