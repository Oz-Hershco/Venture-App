import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:venture_app/models/user.dart';
import 'package:venture_app/models/venture.dart';
import 'package:venture_app/providers/user_provider.dart';
import 'package:venture_app/providers/ventures_provider.dart';
import 'package:venture_app/screens/EditProfileScreen.dart';
import 'package:venture_app/screens/startscreens/StartScreen.dart';
import 'package:venture_app/widgets/ActivityTabs.dart';
import 'package:venture_app/widgets/OptionsBottomSheet.dart';
import 'package:venture_app/widgets/ProfileImage.dart';
import 'package:venture_app/widgets/VentureCard.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile';
  final List<Venture> userCreatedVentures;
  ProfileScreen({this.userCreatedVentures});
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void _showProfileSettingsSheet() {
    List<Map<String, dynamic>> options = [
      // {
      //   'leadingSrc': 'assets/images/notification_icon.png',
      //   'title': 'Notifications',
      //   'subtitle': 'Manage what you would like to be notified about.',
      // },
      {
        'leadingSrc': 'assets/images/edit_icon.png',
        'title': 'Edit',
        'subtitle': 'Update your display name, bio and profile pic.',
      },
      {
        'leadingSrc': 'assets/images/power_icon.png',
        'title': 'Logout',
        'subtitle': 'Go back to login screen.',
      },
    ];

    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: OptionsBottomSheet(
              options: options,
              onTap: (String title) {
                switch (title) {
                  case 'Notifications':
                    Navigator.of(context).pop();

                    break;
                  case 'Edit':
                    Navigator.of(context).pop();
                    Navigator.of(context)
                        .pushNamed(EditProfileScreen.routeName);
                    break;
                  case 'Logout':
                    FirebaseAuth.instance.signOut();
                    Navigator.of(context).pop();
                    break;
                  default:
                }
              },
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final venturesData = Provider.of<VenturesProvider>(context);
    final userData = Provider.of<UserProvider>(context);
    final ventures = venturesData.list;
    final user = userData.item;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: _showProfileSettingsSheet,
                        child: Container(
                          height: 25,
                          child: Image.asset('assets/images/settings_icon.png'),
                        ),
                      )
                    ],
                  ),
                  ProfileImage(
                    imgSrc: user.profilePic,
                  ),
                  Text(
                    user.name,
                    style: TextStyle(
                      height: 2,
                      fontSize: 20,
                      fontFamily: 'Heebo',
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    user.about,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Heebo',
                        fontWeight: FontWeight.w300,
                        color: Colors.black.withOpacity(.5)),
                  )
                ],
              ),
            ),
            ActivityTabs(
              myfeedcardlist: [
                ...ventures
                    .where((venture) => venture.creatorId == user.uid)
                    .map((venture) {
                  return VentureCard(
                    venture: venture,
                  );
                }).toList()
              ],
              mysavedcardlist: [
                ...ventures
                    .where((venture) =>
                        user.savedVenturesList.contains(venture.id))
                    .map((venture) {
                  return VentureCard(
                    venture: venture,
                  );
                }).toList()
              ],
            )
          ],
        ),
      ),
    );
  }
}
