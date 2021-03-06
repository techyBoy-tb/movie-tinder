import 'package:flutter/material.dart';
import 'package:movie_tinder/ui/constants.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: backgroundColour,
      body: Container(
        width: size.width,
        child: Center(
          child: Text(
            "Movie Tinder: Match it, watch it!",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: size.width * 0.1
            )
          )
        )
      )
    );
  }
}
