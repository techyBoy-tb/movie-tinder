import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_tinder/bloc/signup/sign_up_bloc.dart';
import 'package:movie_tinder/repositories/userRepository.dart';
import 'package:movie_tinder/ui/widgets/signUpForm.dart';

import '../constants.dart';

class SignUp extends StatelessWidget {
  final UserRepository _userRepository;

  SignUp({@required UserRepository userRepository}) : assert (userRepository != null), _userRepository = userRepository;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Sign up"),
          centerTitle: true,
          backgroundColor: backgroundColour,
          elevation: 0
      ),
      body: BlocProvider<SignUpBloc>(
        create: (context) => SignUpBloc(userRepository: _userRepository),
        child: SignUpForm(
            userRepository: _userRepository
        ),
      ),
    );
  }
}
