import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:venture_app/models/user.dart';
import 'package:venture_app/providers/user_provider.dart';
import 'package:venture_app/screens/ExploreScreen.dart';
import 'package:venture_app/screens/TabsScreen.dart';
import 'package:venture_app/screens/startscreens/SignInScreen.dart';
import 'package:venture_app/screens/startscreens/SignUpScreen.dart';

class StartScreen extends StatelessWidget {
  static const routeName = '/welcome';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed))
                            return Theme.of(context)
                                .primaryColor
                                .withOpacity(0.4);
                          return Theme.of(context)
                              .primaryColor; // Defer to the widget's default.
                        },
                      ),
                      overlayColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed))
                            return Colors.transparent;
                          return null; // Defer to the widget's default.
                        },
                      ),
                    ),
                    onPressed: () {
                      // FirebaseAuth.instance.signInAnonymously().then((value) {
                      //   final userData =
                      //       Provider.of<UserProvider>(context, listen: false);
                      //   userData.updateUser(null);
                      // });
                    },
                    child: Text(
                      'Skip',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Venture',
                    style: TextStyle(
                      fontSize: Theme.of(context).textTheme.headline2.fontSize,
                      fontFamily:
                          Theme.of(context).textTheme.headline2.fontFamily,
                      color: Colors.black.withOpacity(.75),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 90,
                    margin: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    child: Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.contain,
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 30),
                    child: Column(
                      children: [
                        Text(
                          'Explore, discover,create.',
                          style: TextStyle(
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .fontSize,
                              color: Colors.black.withOpacity(.75)),
                        ),
                        Text('A social communicty of the daily traveler',
                            style: TextStyle(
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    .fontSize,
                                color: Colors.black.withOpacity(.50),
                                fontFamily: 'Heebo',
                                fontWeight: FontWeight.w300)),
                      ],
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 40,
                        padding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                        margin: EdgeInsets.only(right: 10),
                        child: Image.asset(
                          'assets/images/apple-logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 45,
                        padding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                        child: Image.asset(
                          'assets/images/google-logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 40,
                        padding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                        margin: EdgeInsets.only(left: 10),
                        child: Image.asset(
                          'assets/images/facebook-logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    color: Colors.black.withOpacity(.5),
                    height: 0.5,
                    width: 150,
                  ),
                  Text(
                    "OR",
                    style: TextStyle(
                        color: Colors.black.withOpacity(.5),
                        fontSize:
                            Theme.of(context).textTheme.bodyText2.fontSize),
                  ),
                  Container(
                    color: Colors.black.withOpacity(.5),
                    height: 0.5,
                    width: 150,
                  )
                ],
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 250,
                        child: OutlinedButton(
                          style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed))
                                  return Colors.black.withOpacity(0.4);
                                return Colors
                                    .black; // Defer to the widget's default.
                              },
                            ),
                            overlayColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed))
                                  return Colors.transparent;
                                return null; // Defer to the widget's default.
                              },
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(
                                context, SignUpScreen.routeName);
                          },
                          child: Text(
                            'Sign up with email',
                            style: TextStyle(
                                fontFamily: 'Heebo',
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account?',
                            style: TextStyle(
                                color: Colors.black.withOpacity(.50),
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .fontSize,
                                fontFamily: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .fontFamily,
                                fontWeight: FontWeight.w300),
                          ),
                          TextButton(
                            style: ButtonStyle(
                              foregroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.pressed))
                                    return Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.4);
                                  return Theme.of(context)
                                      .primaryColor; // Defer to the widget's default.
                                },
                              ),
                              overlayColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.pressed))
                                    return Colors.transparent;
                                  return null; // Defer to the widget's default.
                                },
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, SignInScreen.routeName);
                            },
                            child: Text('Sign In',
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .bodyText2
                                        .fontSize,
                                    fontFamily: Theme.of(context)
                                        .textTheme
                                        .bodyText2
                                        .fontFamily,
                                    fontWeight: FontWeight.w300)),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
