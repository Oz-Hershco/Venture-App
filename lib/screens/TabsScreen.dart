import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:venture_app/models/user.dart';
import 'package:venture_app/providers/user_provider.dart';
import 'package:venture_app/providers/users_provider.dart';
import 'package:venture_app/providers/ventures_provider.dart';
import 'package:venture_app/screens/ExploreScreen.dart';
import 'package:venture_app/screens/ProfileScreen.dart';
import 'package:venture_app/screens/VentureFeedScreen.dart';
import 'package:venture_app/widgets/SignInSuggestionDialog.dart';

class TabScreens extends StatefulWidget {
  static const routeName = '/app-tabs';
  @override
  _TabScreensState createState() => _TabScreensState();
}

class _TabScreensState extends State<TabScreens> {
  @override
  void initState() {
    final venturesData = Provider.of<VenturesProvider>(context, listen: false);
    venturesData.fetchAndSetVentures();
    FirebaseAuth.instance.currentUser().then((user) {
      Firestore.instance
          .collection('users')
          .document(user.uid)
          .get()
          .then((doc) {
        var data = doc.data;
        final userData = Provider.of<UserProvider>(context, listen: false);
        userData.updateUser(
          User(
            uid: user.uid,
            name: data['name'],
            about: data['about'],
            profilePic: data['profilePic'],
            savedVenturesList: data['savedVenturesList'],
          ),
        );
      });
    });

    super.initState();
  }

  final List<Map<String, Object>> _pages = [
    {
      'page': ExploreScreen(),
    },
    {
      'page': VentureFeedScreen(),
    },
    {
      'page': ProfileScreen(),
    },
  ];

  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    final userData = Provider.of<UserProvider>(context, listen: false);
    final user = userData.item;
    if (user == null && index == 2) {
      _showSignInSuggestionDialog();
    } else {
      setState(() {
        _selectedPageIndex = index;
      });
    }
  }

  void _showSignInSuggestionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => SignInSuggestionDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: _pages[_selectedPageIndex]['page'],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 10,
        unselectedFontSize: 10,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Container(
              height: 20,
              margin: EdgeInsets.only(bottom: 5),
              child: (_selectedPageIndex == 0
                  ? new Image.asset(
                      'assets/images/explore_nav_icon.png',
                    )
                  : new Image.asset(
                      'assets/images/explore_nav_icon.png',
                      color: Color.fromRGBO(0, 0, 0, 0.5),
                    )),
            ),
            label: 'EXPLORE',
          ),
          BottomNavigationBarItem(
            icon: Container(
              height: 20,
              margin: EdgeInsets.only(bottom: 5),
              child: (_selectedPageIndex == 1
                  ? new Image.asset(
                      'assets/images/feed_nav_icon.png',
                    )
                  : new Image.asset(
                      'assets/images/feed_nav_icon.png',
                      color: Color.fromRGBO(0, 0, 0, 0.5),
                    )),
            ),
            label: 'VENTURE FEED',
          ),
          BottomNavigationBarItem(
            icon: Container(
              height: 20,
              margin: EdgeInsets.only(bottom: 5),
              child: (_selectedPageIndex == 2
                  ? new Image.asset(
                      'assets/images/profile_nav_icon.png',
                    )
                  : new Image.asset(
                      'assets/images/profile_nav_icon.png',
                      color: Color.fromRGBO(0, 0, 0, 0.5),
                    )),
            ),
            label: 'PROFILE',
          ),
        ],
        currentIndex: _selectedPageIndex,
        selectedItemColor: Colors.black,
        onTap: _selectPage,
      ),
    );
  }
}
