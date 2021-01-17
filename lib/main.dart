import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_tinder/bloc/blocDelegate.dart';
import 'package:movie_tinder/ui/screens/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  BlocSupervisor.delegate = SimpleBlocDelegate();

  runApp(Home());
}