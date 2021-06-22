import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:venture_app/models/user.dart';

class UserProvider with ChangeNotifier {
  User _user;

  User get item {
    return _user;
  }

  Future<void> updateUser(User user) async {
    try {
      Firestore.instance.collection('users').document(user.uid).updateData({
        'about': user.about,
        'email': user.email,
        'profilePic': user.profilePic,
        'username': user.name,
        'savedVenturesList': user.savedVenturesList,
      });
      _user = user;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
