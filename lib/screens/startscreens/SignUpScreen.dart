import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:venture_app/constants/functions.dart';
import 'package:venture_app/models/http_exception.dart';
import 'package:venture_app/models/user.dart';
import 'package:venture_app/providers/user_provider.dart';
import 'package:venture_app/widgets/Spinner.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = '/signup';
  const SignUpScreen({Key key}) : super(key: key);
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _displayName = "";
  String _email = "";
  String _password = "";
  String _confirmPassword = "";
  bool _isLoading = false;
  final _auth = FirebaseAuth.instance;

  Future<void> _handleSignUp() async {
    setState(() {
      _isLoading = true;
    });

    final userData = Provider.of<UserProvider>(context, listen: false);
    AuthResult authResult;
    try {
      authResult = await _auth.createUserWithEmailAndPassword(
          email: _email, password: _password);
      await Firestore.instance
          .collection('users')
          .document(authResult.user.uid)
          .setData({
        'username': _displayName,
        'email': _email,
        'about': "",
        'profilePic': "",
        'savedVenturesList': [],
      });

      await userData.updateUser(
        User(
          uid: authResult.user.uid,
          name: _displayName,
          email: _email,
          about: "",
          profilePic: "",
          savedVenturesList: [],
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
    return _displayName.length > 0 &&
        _email.length > 0 &&
        _password.length >= 6 &&
        _password == _confirmPassword &&
        validateEmail(_email);
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
          'Sign Up',
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
                          width: 280,
                          margin: EdgeInsets.only(top: 30),
                          child: Column(
                            children: [
                              Text(
                                "Get on the adventure!",
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
                                "After signing up you'll be able to create and share new ventures with your fellow travelers",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .fontSize,
                                  color: Colors.black.withOpacity(.50),
                                  fontFamily: 'Heebo',
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
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
                                  _displayName = val;
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
                                labelText: 'Display Name',
                                hintText: 'How you wish everyone to see you',
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
                                  return 'Please enter a name';
                                } else if (value.length < 2) {
                                  return 'Please enter a name longer than one letter';
                                }
                                return null;
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 30),
                              child: TextFormField(
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
                                  } else if (value.length < 6) {
                                    return 'Please enter a password with at least 6 keys';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 30),
                              child: TextFormField(
                                onChanged: (val) {
                                  setState(() {
                                    _confirmPassword = val;
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
                                  labelText: 'Confirm Password',
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
                                  } else if (value.length < 6) {
                                    return 'Please enter a password with at least 6 keys';
                                  } else if (_password != _confirmPassword) {
                                    return "Password doesn't match original";
                                  }
                                  return null;
                                },
                              ),
                            ),
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
                                        _handleSignUp();
                                      }
                                    },
                                    child: const Text(
                                      'Sign Up',
                                      style: TextStyle(
                                          fontFamily: 'Heebo',
                                          fontWeight: FontWeight.w400),
                                    ),
                                  )),
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
