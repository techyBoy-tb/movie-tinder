import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:movie_tinder/bloc/auth/auth_bloc.dart';
import 'package:movie_tinder/bloc/profile/profile_bloc.dart';
import 'package:movie_tinder/bloc/profile/profile_state.dart';
import 'package:movie_tinder/repositories/userRepository.dart';
import 'package:movie_tinder/ui/constants.dart';
import 'package:movie_tinder/ui/widgets/gender.dart';

@immutable
class ProfileForm extends StatefulWidget {
  final UserRepository _userRepository;

  ProfileForm({@required UserRepository userRepository}) : assert (userRepository != null), _userRepository = userRepository;

  @override
  _ProfileFormState createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final TextEditingController _nameController = TextEditingController();

  String gender, interestedIn;
  DateTime age;
  File photo;
  GeoPoint location;
  ProfileBloc _profileBloc;

  UserRepository get _userRepository => widget._userRepository;
  bool get isPopulated => _nameController.text.isNotEmpty && gender !=null
      && interestedIn !=null && age !=null && photo !=null;

  bool isButtonEnabled(ProfileState state) {
    return isPopulated && !state.isSubmitting;
  }

  _getLocation() async {
     Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
     location = GeoPoint(position.latitude, position.longitude);
  }

  _onSubmitted() async {
    await _getLocation();
    _profileBloc.add(
      Submitted(
        name: _nameController.text,
        age: age,
        location: location,
        gender: gender,
        interestedIn: interestedIn,
        photo: photo),
    );
  }

  @override
  void initState() {
    _getLocation();
    _profileBloc = BlocProvider.of<ProfileBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state.isFailure) {
          print("Failed to create user profile");
          Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget> [
                    Text("Profile creation unsuccessful"),
                    Icon(Icons.error)
                  ]
                )
              ),
            );
        }
        if (state.isSubmitting) {
          print("Submitting user profile");
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
                content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget> [
                      Text("Submitting"),
                      CircularProgressIndicator()
                    ]
                )
            ),
            );
        }
        if (state.isSuccess) {
          print("User profile created!");
          BlocProvider.of<AuthBloc>(context).add(LoggedIn());
        }
      },
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              color: backgroundColour,
              width: size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget> [
                  Container(
                    width: size.width,
                    child: CircleAvatar(
                      radius: size.width * 0.3,
                      backgroundColor: Colors.transparent,
                      child: photo == null ? GestureDetector(
                        onTap: () async {
                          File getPic = await FilePicker.getFile(type: FileType.image);
                          if (getPic != null) {
                            setState(() {
                              photo = getPic;
                            });
                          }
                        },
                        child: Image.asset('assets/profilePhoto.png'),
                      ) : GestureDetector(
                        onTap: () async {
                          File getPic = await FilePicker.getFile(type: FileType.image);
                          if (getPic != null) {
                            setState(() {
                              photo = getPic;
                            });
                          }
                        },
                        child: CircleAvatar(
                          radius: size.width * 0.3,
                          backgroundImage: FileImage(photo),
                        ),
                      ),
                    ),
                  ),
                  textFieldWidget(_nameController, "Display name", size),
                  GestureDetector(
                    onTap: () {
                      DatePicker.showDatePicker(
                          context,
                          showTitleActions: true,
                          minTime: DateTime(1900, 1, 1),
                          maxTime: DateTime(DateTime.now().year - 18, DateTime.now().month, DateTime.now().day),
                          onConfirm: (date) {
                            setState(() {
                              age = date;
                            });
                            print("Age: $age");
                          },
                        );
                      },
                      child: Text(
                          "Enter date of birth",
                          style: TextStyle(color: Colors.white, fontSize: size.width * 0.08),
                      ),
                  ),
                  SizedBox(
                    height: 10.0
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget> [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: size.height * 0.02),
                        child: Text(
                            "You are?",
                            style: TextStyle(color: Colors.white, fontSize: size.width * 0.08),
                        )
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget> [
                          genderWidget(FontAwesomeIcons.venus, "Female", size, gender, () {
                            setState(() {
                              gender = "Female";
                            });
                          }),
                          genderWidget(FontAwesomeIcons.mars, "Male", size, gender, () {
                            setState(() {
                              gender = "Male";
                            });
                          }),
                          genderWidget(FontAwesomeIcons.transgender, "Trans/Other", size, gender, () {
                            setState(() {
                              gender = "Trans/Other";
                            });
                          }),
                        ],
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: size.width * 0.2,),
                         child: Text(
                          "You like?",
                          style: TextStyle(color: Colors.white, fontSize: size.width * 0.08),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget> [
                          genderWidget(FontAwesomeIcons.venus, "Female", size, interestedIn, () {
                            setState(() {
                              interestedIn = "Female";
                            });
                          }),
                          genderWidget(FontAwesomeIcons.mars, "Male", size, interestedIn, () {
                            setState(() {
                              interestedIn = "Male";
                            });
                          }),
                          genderWidget(FontAwesomeIcons.transgender, "Trans/Other", size, interestedIn, () {
                            setState(() {
                              interestedIn = "Trans/Other";
                            });
                          }),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
                    child: GestureDetector(
                      onTap: () {
                        if (isButtonEnabled(state)) {
                          _onSubmitted();
                        } else {}
                      },
                      child: Container(
                        width: size.width * 0.8,
                        height: size.height * 0.06,
                        decoration: BoxDecoration(
                          color: isButtonEnabled(state) ? Colors.white : Colors.grey,
                          borderRadius: BorderRadius.circular(size.height * 0.05),
                        ),
                        child: Center(
                          child: Text(
                              "Create my profile",
                              style: TextStyle(fontSize: size.height * 0.025, color: Colors.blue)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget textFieldWidget(controller, text, size) {
  return Padding(
    padding: EdgeInsets.all(size.height * 0.02),
    child: TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: text,
        labelStyle: TextStyle(color: Colors.white, fontSize: size.height * 0.03),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 1.0),
        ),
      ),
    )
  );
}