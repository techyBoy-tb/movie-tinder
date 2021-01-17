import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_tinder/bloc/profile/profile_bloc.dart';
import 'package:movie_tinder/repositories/userRepository.dart';
import 'package:movie_tinder/ui/constants.dart';
import 'package:movie_tinder/ui/widgets/profileForm.dart';

class Profile extends StatelessWidget {
  final UserRepository _userRepository;
  final userId;

  Profile({
    @required UserRepository userRepository,String userId})
      : assert (userRepository != null && userId != null),
        _userRepository = userRepository, userId = userId;

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile setup"),
        centerTitle: true,
        backgroundColor: backgroundColour,
        elevation: 0,
      ),
      body: BlocProvider<ProfileBloc>(
        create: (context) => ProfileBloc(userRepository: _userRepository),
        child: ProfileForm(
          userRepository: _userRepository,
        )
      )
    );
  }
}
