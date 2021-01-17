import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_tinder/bloc/auth/auth_bloc.dart';
import 'package:movie_tinder/repositories/userRepository.dart';
import 'package:movie_tinder/ui/screens/login.dart';
import 'package:movie_tinder/ui/screens/profile.dart';
import 'package:movie_tinder/ui/screens/splash.dart';
import 'package:movie_tinder/ui/widgets/tabs.dart';

// class Home extends StatefulWidget {
//   @override
//   _HomeState createState() => _HomeState();
// }
//
// class _HomeState extends State<Home> {
//   final UserRepository _userRepository = UserRepository();
//   AuthBloc _authBloc;
//
//   @override
//   void initState() {
//     super.initState();
//     // Firebase.initializeApp().whenComplete(() => {
//       _authBloc = AuthBloc(userRepository: _userRepository);
//       _authBloc.add(AppStarted());
//     // });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => _authBloc,
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         home: BlocBuilder(
//           bloc: _authBloc,
//           builder: (BuildContext context, AuthState state) {
//             if (state is Uninitialised) {
//               return SplashScreen();
//             } else if (state is Authenticated) {
//               return Tabs();
//             } else if (state is AuthenticatedButNotSet) {
//               return Profile(
//                 userRepository: _userRepository,
//                 userId: state.userId
//               );
//             } else if(state is Unauthenticated) {
//               return Login(userRepository: _userRepository);
//             } else {
//               return Container();
//             }
//           }
//         )
//       ),
//     );
//   }
// }

class Home extends StatelessWidget {
  final UserRepository _userRepository;

  Home({@required UserRepository userRepository}) : assert (userRepository != null), _userRepository = userRepository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    debugShowCheckedModeBanner: false,
    home: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is Uninitialised) {
            return SplashScreen();
          } else if (state is Authenticated) {
            return Tabs(userId: state.userId);
          } else if (state is AuthenticatedButNotSet) {
            return Profile(
              userRepository: _userRepository,
              userId: state.userId
            );
          } else if(state is Unauthenticated) {
            return Login(userRepository: _userRepository);
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
