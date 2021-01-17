
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_tinder/bloc/login/login_bloc.dart';
import 'package:movie_tinder/repositories/userRepository.dart';
import 'package:movie_tinder/ui/widgets/loginForm.dart';

import '../constants.dart';

class Login extends StatelessWidget {
  final UserRepository _userRepository;

  Login({@required UserRepository userRepository}) : assert (userRepository != null), _userRepository = userRepository;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
              "Welcome",
              style: TextStyle(
              fontSize: 36.0
            )
          ),
          centerTitle: true,
          backgroundColor: backgroundColour,
          elevation: 0
      ),
      body: BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(userRepository: _userRepository),
        child: LoginForm(
            userRepository: _userRepository
        ),
      ),
    );
  }
}
