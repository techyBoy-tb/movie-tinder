import 'package:cloud_firestore/cloud_firestore.dart';

class User {

  String uuid;
  String name;
  String gender;
  String interestedIn;
  String photo;
  Timestamp age;
  GeoPoint location;


  User({
    this.uuid,
    this.name,
    this.gender,
    this.interestedIn,
    this.photo,
    this.age,
    this.location});

}