import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_tinder/bloc/auth/auth_bloc.dart';
import 'package:movie_tinder/repositories/userRepository.dart';
import 'package:movie_tinder/ui/screens/login.dart';
import 'package:movie_tinder/ui/screens/signUp.dart';
import 'package:movie_tinder/ui/screens/splash.dart';
import 'package:movie_tinder/ui/widgets/tabs.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final UserRepository _userRepository = UserRepository();
  AuthBloc _authBloc;

  @override
  void initState() {
    super.initState();
    // Firebase.initializeApp().whenComplete(() => {
      _authBloc = AuthBloc(userRepository: _userRepository);
      _authBloc.add(AppStarted());
    // });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _authBloc,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: BlocBuilder(
          bloc: _authBloc,
          builder: (BuildContext context, AuthState state) {
            if (state is Uninitialised) {
              return SplashScreen();
            } else
              return Login(userRepository: _userRepository);
          }
        )
      ),
    );
  }
}
