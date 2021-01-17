import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:movie_tinder/bloc/search/search_bloc.dart';
import 'package:movie_tinder/models/user.dart';
import 'package:movie_tinder/repositories/searchRepository.dart';
import 'package:movie_tinder/ui/widgets/iconWidget.dart';
import 'package:movie_tinder/ui/widgets/profile.dart';
import 'package:movie_tinder/ui/widgets/userGender.dart';

class Searches extends StatefulWidget {
  final String userId;

  const Searches({this.userId});

  @override
  _SearchesState createState() => _SearchesState();
}

class _SearchesState extends State<Searches> {
  SearchRepository _searchRepository = SearchRepository();
  SearchBloc _searchBloc;
  User _user, _currentUser;
  int locationDifference;

  Future<int> getDifference(GeoPoint userLocation) async {
    Position currentPosition = await Geolocator.getCurrentPosition();
    double location = await Geolocator.distanceBetween(userLocation.longitude, userLocation.longitude, currentPosition.latitude, currentPosition.longitude);
    locationDifference = location.toInt();
  }

  @override
  void initState() {
    _searchBloc = SearchBloc(searchRepository: _searchRepository);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocBuilder<SearchBloc, SearchState>(
      bloc: _searchBloc,
      builder: (context, state) {
        if (state is InitialSearchState) {
          _searchBloc.add(LoadUserEvent(userId: widget.userId));
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.blueGrey),
            ),
          );
        }
        if (state is LoadingState) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.blueGrey),
            ),
          );
        }
        if (state is LoadUserState) {
          _user = state.user;
          _currentUser = state.currentUser;
          getDifference(_user.location);
          if (_user.location == null) {
            return Text("Nobody loves you", style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.black)
            );
          } else {
            return ProfileWidget(
              padding: size.height * 0.035,
              photoHeight: size.height * 0.824,
              photoWidth: size.width * 0.95,
              photo: _user.photo,
              clipRadius: size.height * 0.02,
              containerHeight: size.height * 0.3,
              containerWidth: size.width * 0.9,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget> [
                    SizedBox(
                      height: size.height * 0.07
                    ),
                    Row(
                      children: <Widget> [
                        userGender(_user.gender),
                        Expanded(
                          child: Text(
                              " " + _user.name + ", " + (DateTime.now().year  - _user.age.toDate().year).toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: size.height * 0.05,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget> [
                        Icon(
                          Icons.location_on,
                          color: Colors.white
                        ),
                        Text(
                            locationDifference != null ? (locationDifference / 1000).floor().toString() + "KM away" : "away",
                          style: TextStyle(
                            color: Colors.white,
                          )
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.05,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget> [
                        // This is the lightning icon!
                        // iconWidget(
                        //     EvaIcons.flash,
                        //         (){
                        //     },
                        //     size.height * 0.04,
                        //     Colors.yellow
                        // ),
                        iconWidget(
                          Icons.clear,
                          (){
                            _searchBloc.add(PassUserEvent(widget.userId, _user.uuid));
                          },
                          size.height * 0.08,
                          Colors.blue
                        ),
                        iconWidget(
                            FontAwesomeIcons.solidHeart,
                            (){
                              _searchBloc.add(SelectUserEvent(
                                  currentUserId:_currentUser.uuid,
                                  selectedUserId: _user.uuid,
                                  selectedName: _currentUser.name,
                                  photoUrl: _currentUser.photo
                              ));
                            },
                            size.height * 0.06,
                            Colors.red
                        ),
                        // This is the filter icon!
                        // iconWidget(
                        //     EvaIcons.options2,
                        //         (){
                        //     },
                        //     size.height * 0.04,
                        //     Colors.white
                        // ),
                      ]
                    )
                  ],
                ),
              ),
            );
          }
        }
        else return Container();
      },
    );
  }
}
