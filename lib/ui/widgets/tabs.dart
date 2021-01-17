import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_tinder/bloc/auth/auth_bloc.dart';
import 'package:movie_tinder/ui/constants.dart';
import 'package:movie_tinder/ui/screens/matches.dart';
import 'package:movie_tinder/ui/screens/messages.dart';
import 'package:movie_tinder/ui/screens/searches.dart';

class Tabs extends StatelessWidget {
  final userId;

  Tabs({this.userId});

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      Searches(userId: userId),
      Matches(),
      Messages()
    ];

    return Theme(
      data: ThemeData(
        primaryColor: backgroundColour,
        accentColor: Colors.white
      ),
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
                "Movie Tinder",
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold
              ),
            ),
            actions: <Widget> [
              IconButton(
                icon: Icon(Icons.exit_to_app),
                onPressed: () {
                  BlocProvider.of<AuthBloc>(context).add(LoggedOut());
                },
              ),
            ],
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(48.0),
              child: Container(
                height: 48.0,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget> [
                    TabBar(
                        tabs: <Widget> [
                          Tab(icon: Icon(Icons.search)),
                          Tab(icon: Icon(Icons.people)),
                          Tab(icon: Icon(Icons.message)),
                        ]
                    )
                  ]
                )
              )
            )
          ),
          body: TabBarView(
            children: pages
          )
        ),
      ),
    );
  }
}

