import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_tinder/models/user.dart';

class SearchRepository {
  final Firestore _firestore;

  SearchRepository({Firestore firestore})
      : _firestore = firestore ?? Firestore.instance;

  Future<User> chooseUser(String currentUserId, String selectedUserId,
      String name, String photoUrl) async {
    await _firestore
        .collection('users')
        .document(currentUserId)
        .collection('chosenList')
        .document(selectedUserId)
        .setData({});

    await _firestore
        .collection('users')
        .document(selectedUserId)
        .collection('chosenList')
        .document(currentUserId)
        .setData({});

    await _firestore
        .collection('users')
        .document(selectedUserId)
        .collection('selectedList')
        .document(currentUserId)
        .setData({
      'name': name,
      'photoUrl': photoUrl
    });

    return getUser(currentUserId);
  }

  Future<User> getUser(String userId) async {
    User _user = User();
    List<String> chosenList = await getChosenList(userId);
    User currentUser = await getUserInfo(userId);

    await _firestore
        .collection('users')
        .getDocuments()
        .then((users) {
          for (var user in users.documents) {
            // REFACTOR THIS
            if (!chosenList.contains(user.documentID)
                && user.documentID != userId
                && currentUser.interestedIn == user['gender']
                && user['interestedIn'] == currentUser.gender) {
              _user.uuid = user.documentID;
              _user.name = user['name'];
              _user.photo = user['photoUrl'];
              _user.age = user['age'];
              _user.location = user['location'];
              _user.gender = user['gender'];
              _user.interestedIn = user['interestedIn'];
              break;
            }
          }
        });
    return _user;
  }

  Future<User> getUserInfo(String userId) async {
    User currentUser = User();
    await _firestore
        .collection('users')
        .document(userId)
        .get()
        .then((user) {
          currentUser.name = user['name'];
          currentUser.photo = user['photoUrl'];
          currentUser.gender = user['gender'];
          currentUser.interestedIn = user['interestedIn'];
    });
    return currentUser;
  }

  Future<User> passUser(String currentUserId, String passUserId) async {
    await _firestore
        .collection('users')
        .document(passUserId)
        .collection('chosenList')
        .document(currentUserId)
        .setData({});

    await _firestore
        .collection('users')
        .document(currentUserId)
        .collection('chosenList')
        .document(passUserId)
        .setData({});
    return getUser(currentUserId);
  }

  Future<List> getChosenList(userId) async {
    List<String> chosenList = [];

    await _firestore
        .collection('users')
        .document(userId)
        .collection('chosenList')
        .getDocuments()
        .then(
          (docs) {
            for (var doc in docs.documents) {
              if (docs.documents != null) {
                chosenList.add(doc.documentID);
              }
            }
          }
      );
    return chosenList;
  }
}