import 'package:flutter/material.dart';
import 'package:venture_app/models/user.dart';

class UsersProvider with ChangeNotifier {
  List<User> _users = [
    User(
      uid: "asdasdasj-daosd8jaiu-kj3wdecs-doijlkmsd",
      name: "Oz Hershco",
      about:
          'I’m just a simple merchant from a simple land and a simple time, traveling through the land, meeting new people and discovering the world. Hoping to enrich everyone with these amazing sights.',
      profilePic:
          'https://cdn.cloudflare.steamstatic.com/steamcommunity/public/images/avatars/0e/0e0e07421d55a36947b865ff75148b9fcd3ff564_full.jpg',
      savedVenturesList: [],
    ),
    User(
      uid: "asdasdasj-8iukjnm-kj3wdecs-0p9oiljhkjmv",
      name: "Johnnie Bravo",
      about:
          'An guy from hope town, just trying to make a living by publishing these things it seems...',
      profilePic: 'https://i.redd.it/0soscn36gad61.png',
      savedVenturesList: [],
    ),
  ];

  List<User> get list {
    return _users;
  }

  void updateUsers(List<User> users) {
    _users = users;
    notifyListeners();
  }
}
