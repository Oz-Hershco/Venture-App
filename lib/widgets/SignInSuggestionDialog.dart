import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:venture_app/screens/startscreens/StartScreen.dart';

class SignInSuggestionDialog extends StatelessWidget {
  const SignInSuggestionDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.all(20),
      contentPadding: EdgeInsets.only(top: 15, bottom: 5, left: 18, right: 18),
      title: const Text(
        'Sign In Required',
        textAlign: TextAlign.center,
      ),
      content: Text(
        "In order to use additional features within the app, signing in is required. Would you like to go back to the start screen to sign in/up?",
        textAlign: TextAlign.center,
        style: TextStyle(
            fontFamily: 'Heebo', fontWeight: FontWeight.w300, fontSize: 16),
      ),
      actions: [
        Container(
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlinedButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed))
                        return Colors.black.withOpacity(0.4);
                      return Colors.black; // Defer to the widget's default.
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
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Not Now',
                  style: TextStyle(
                    fontFamily: 'Heebo',
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.disabled))
                          return Colors.black.withOpacity(0.25);
                        return Theme.of(context)
                            .primaryColor; // Defer to the widget's default.
                      },
                    ),
                    elevation: MaterialStateProperty.all(0)),
                onPressed: () {
                 Navigator.of(context).pop();
                 FirebaseAuth.instance.signOut();
                },
                child: Text(
                  'Okay',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
