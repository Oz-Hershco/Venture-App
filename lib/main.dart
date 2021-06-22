import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:venture_app/models/user.dart';
import 'package:venture_app/providers/user_provider.dart';
import 'package:venture_app/providers/users_provider.dart';
import 'package:venture_app/providers/venture_provider.dart';
import 'package:venture_app/providers/ventures_provider.dart';
import 'package:venture_app/screens/AddNewVentureScreen.dart';
import 'package:venture_app/screens/EditProfileScreen.dart';
import 'package:venture_app/screens/TabsScreen.dart';
import 'package:venture_app/screens/VentureScreen.dart';
import 'package:venture_app/screens/startscreens/ForgotPasswordScreen.dart';
import 'package:venture_app/screens/startscreens/SignInScreen.dart';
import 'package:venture_app/screens/startscreens/SignUpScreen.dart';
import 'package:venture_app/widgets/ImageGallery.dart';
import './screens/startscreens/StartScreen.dart';

void main() {
  runApp(VentureApp());
}

class VentureApp extends StatelessWidget {
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Color.fromRGBO(93, 108, 219, 1),
        statusBarIconBrightness: Brightness.light));
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentScope = FocusScope.of(context);
        if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
          FocusManager.instance.primaryFocus.unfocus();
        }
      },
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (ctx) => UserProvider(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => VenturesProvider(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => VentureProvider(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => UsersProvider(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => UserProvider(),
          ),
        ],
        child: MaterialApp(
          title: 'Venture',
          theme: ThemeData(
            primaryColor: Color.fromRGBO(69, 77, 216, 1),
            primaryColorLight: Color.fromRGBO(93, 108, 219, 1),
            accentColor: Color.fromRGBO(15, 192, 192, 1),
            errorColor: Color.fromRGBO(255, 20, 20, 1),
            textTheme: TextTheme(
              headline2: TextStyle(fontFamily: 'Handlee', fontSize: 80),
              headline6: TextStyle(fontFamily: 'Heebo', fontSize: 18),
              bodyText2: TextStyle(
                fontFamily: 'Heebo',
                fontSize: 16,
              ),
              bodyText1: TextStyle(
                fontFamily: 'Heebo',
              ),
            ),
          ),
          home: StreamBuilder(
            stream: FirebaseAuth.instance.onAuthStateChanged,
            builder: (ctx, userSnapshot) {
              if (userSnapshot.hasData) {
                return TabScreens();
              }
              return StartScreen();
            },
          ),
          routes: {
            AddNewVentureScreen.routeName: (ctx) => AddNewVentureScreen(),
            TabScreens.routeName: (ctx) => TabScreens(),
            ImageGallery.routeName: (ctx) => ImageGallery(),
            EditProfileScreen.routeName: (ctx) => EditProfileScreen(),
            StartScreen.routeName: (ctx) => StartScreen(),
            SignInScreen.routeName: (ctx) => SignInScreen(),
            SignUpScreen.routeName: (ctx) => SignUpScreen(),
            ForgotPasswordScreen.routeName: (ctx) => ForgotPasswordScreen(),
            VentureScreen.routeName: (ctx) => VentureScreen(),
          },
          // home: AddNewSiteScreen(),
        ),
      ),
    );
  }
}
