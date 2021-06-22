import 'package:flutter/material.dart';
import 'package:venture_app/constants/functions.dart';
import 'package:venture_app/screens/startscreens/ResetPasswordScreen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const routeName = '/forgotpw';
  const ForgotPasswordScreen({Key key}) : super(key: key);
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
          'Forgot Password',
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
      body: Container(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 280,
                  margin: EdgeInsets.only(top: 30),
                  child: Text(
                    "Enter the email you signed up with and we'll send you a brand new reset link",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: Theme.of(context).textTheme.bodyText2.fontSize,
                      color: Colors.black.withOpacity(.50),
                      fontFamily: 'Heebo',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: TextFormField(
                        style: TextStyle(
                            color: Colors.black,
                            fontSize:
                                Theme.of(context).textTheme.bodyText1.fontSize),
                        decoration: InputDecoration(
                          labelStyle: TextStyle(height: .5),
                          hintStyle:
                              TextStyle(color: Colors.black.withOpacity(.25)),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: 'Email',
                          hintText: 'Your account email',
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                width: .5, color: Colors.black.withOpacity(.5)),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                width: .5,
                                color: Theme.of(context).primaryColor),
                          ),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(
                                width: .5, color: Colors.black.withOpacity(.5)),
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
                    Center(
                      child: Container(
                          margin: EdgeInsets.only(top: 40),
                          width: 250,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                    if (states.contains(MaterialState.disabled))
                                      return Colors.black.withOpacity(0.25);
                                    return Theme.of(context)
                                        .accentColor; // Defer to the widget's default.
                                  },
                                ),
                                elevation: MaterialStateProperty.all(0)),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  return ResetPasswordScreen();
                                }),
                              );
                              // Validate will return true if the form is valid, or false if
                              // the form is invalid.
                              if (_formKey.currentState.validate()) {
                                // Process data.
                              }
                            },
                            child: const Text(
                              'Send Reset Link',
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
    );
  }
}
