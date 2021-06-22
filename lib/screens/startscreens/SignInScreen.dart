import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:venture_app/constants/functions.dart';
import 'package:venture_app/models/http_exception.dart';
import 'package:venture_app/models/user.dart';
import 'package:venture_app/providers/user_provider.dart';
import 'package:venture_app/screens/TabsScreen.dart';
import 'package:venture_app/screens/startscreens/ForgotPasswordScreen.dart';
import 'package:venture_app/widgets/Spinner.dart';

class SignInScreen extends StatefulWidget {
  static const routeName = '/signin';
  const SignInScreen({Key key}) : super(key: key);
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _email = "";
  String _password = "";
  bool _isLoading = false;
  final _auth = FirebaseAuth.instance;

  Future<void> _handleSignIn() async {
    setState(() {
      _isLoading = true;
    });

    AuthResult authResult;
    var userFirebaseDoc;
    final userData = Provider.of<UserProvider>(context, listen: false);

    try {
      authResult = await _auth.signInWithEmailAndPassword(
          email: _email, password: _password);
      userFirebaseDoc = await Firestore.instance
          .collection('users')
          .document(authResult.user.uid)
          .get();
      await userData.updateUser(
        User(
          uid: authResult.user.uid,
          name: userFirebaseDoc['username'],
          email: userFirebaseDoc['email'],
          about: userFirebaseDoc['about'].length > 0
              ? userFirebaseDoc['about']
              : "",
          profilePic: userFirebaseDoc['profilePic'].length > 0
              ? userFirebaseDoc['profilePic']
              : "",
          savedVenturesList: userFirebaseDoc['savedVenturesList'].length > 0
              ? userFirebaseDoc['savedVenturesList']
              : [],
        ),
      );

      Navigator.of(context).pop();
    } on PlatformException catch (error) {
      var message = 'An error occured, please check your credentials!';
      if (error.message != null) {
        message = error.message;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    } catch (error) {
      print(error);
    }

    setState(() {
      _isLoading = false;
    });
  }

  bool _formValidated() {
    return _email.length > 0 && _password.length > 0 && validateEmail(_email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          icon: Container(
              height: 20,
              child: new Image.asset(
                "assets/images/chev-left.png",
                fit: BoxFit.contain,
              )),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.white,
        title: Text(
          'Sign In',
          style: TextStyle(
            color: Colors.black,
            fontSize: Theme.of(context).textTheme.bodyText2.fontSize,
            fontWeight: FontWeight.w300,
          ),
        ),
        elevation: 0,
        bottom: PreferredSize(
            child: Container(
              color: Colors.black,
              height: 0.2,
            ),
            preferredSize: Size.fromHeight(0)),
      ),
      body: _isLoading
          ? Spinner(
              color: Theme.of(context).accentColor,
              sizeWidth: 40,
              sizeHeight: 40,
              circleStrokeWidth: 4,
            )
          : SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 30),
                          child: Column(
                            children: [
                              Text(
                                "Welcome back. It's time to venture!",
                                style: TextStyle(
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .fontSize,
                                  color: Colors.black.withOpacity(.75),
                                  height: 1.5,
                                ),
                              ),
                              Text(
                                  'Select one of the login options to continue',
                                  style: TextStyle(
                                      fontSize: Theme.of(context)
                                          .textTheme
                                          .bodyText2
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
                              padding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 10),
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
                              padding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 10),
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
                              padding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 10),
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
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .fontSize),
                        ),
                        Container(
                          color: Colors.black.withOpacity(.5),
                          height: 0.5,
                          width: 150,
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            TextFormField(
                              onChanged: (val) {
                                setState(() {
                                  _email = val.trim();
                                });
                              },
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .fontSize),
                              decoration: InputDecoration(
                                labelStyle: TextStyle(height: .5),
                                hintStyle: TextStyle(
                                    color: Colors.black.withOpacity(.25)),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                labelText: 'Email',
                                hintText: 'Your account email',
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      width: .5,
                                      color: Colors.black.withOpacity(.5)),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      width: .5,
                                      color: Theme.of(context).primaryColor),
                                ),
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      width: .5,
                                      color: Colors.black.withOpacity(.5)),
                                ),
                              ),
                              validator: (String value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter an email address';
                                } else if (!validateEmail(value)) {
                                  return 'Please enter a valid email address';
                                }
                                return null;
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 30),
                              child: TextFormField(
                                onChanged: (val) {
                                  setState(() {
                                    _password = val;
                                  });
                                },
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .fontSize),
                                obscureText: true,
                                decoration: InputDecoration(
                                  labelStyle: TextStyle(height: .5),
                                  hintStyle: TextStyle(
                                      color: Colors.black.withOpacity(.25)),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  labelText: 'Password',
                                  hintText: 'Your account password',
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        width: .5,
                                        color: Colors.black.withOpacity(.5)),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        width: .5,
                                        color: Theme.of(context).primaryColor),
                                  ),
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        width: .5,
                                        color: Colors.black.withOpacity(.5)),
                                  ),
                                ),
                                validator: (String value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a password';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Center(
                                  child: Container(
                                    margin: EdgeInsets.only(top: 40),
                                    width: 250,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty
                                              .resolveWith<Color>(
                                            (Set<MaterialState> states) {
                                              if (!_formValidated())
                                                return Colors.black
                                                    .withOpacity(0.25);
                                              return Theme.of(context)
                                                  .accentColor; // Defer to the widget's default.
                                            },
                                          ),
                                          elevation:
                                              MaterialStateProperty.all(0)),
                                      onPressed: () {
                                        // Validate will return true if the form is valid, or false if
                                        // the form is invalid.
                                        if (_formKey.currentState.validate()) {
                                          // Process data.
                                          _handleSignIn();
                                        }
                                      },
                                      child: const Text(
                                        'Sign In',
                                        style: TextStyle(
                                            fontFamily: 'Heebo',
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ),
                                ),
                                TextButton(
                                    style: ButtonStyle(
                                      foregroundColor: MaterialStateProperty
                                          .resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                          if (states
                                              .contains(MaterialState.pressed))
                                            return Theme.of(context)
                                                .primaryColor
                                                .withOpacity(0.4);
                                          return Theme.of(context)
                                              .primaryColor; // Defer to the widget's default.
                                        },
                                      ),
                                      overlayColor: MaterialStateProperty
                                          .resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                          if (states
                                              .contains(MaterialState.pressed))
                                            return Colors.transparent;
                                          return null; // Defer to the widget's default.
                                        },
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) {
                                          return ForgotPasswordScreen();
                                        }),
                                      );
                                    },
                                    child: Text(
                                      'Forgot password?',
                                      style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.w300,
                                          decoration: TextDecoration.underline),
                                    ))
                              ],
                            ),
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
