import 'package:flutter/material.dart';
import 'package:venture_app/screens/startscreens/SignInScreen.dart';

class ResetPasswordScreen extends StatefulWidget {
  static const routeName = '/resetpw';
  const ResetPasswordScreen({Key key}) : super(key: key);
  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
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
          'Reset Password',
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
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 280,
                    margin: EdgeInsets.only(top: 30),
                    child: Text(
                      "Choose your shiney new password!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.bodyText2.fontSize,
                        color: Colors.black.withOpacity(.50),
                        fontFamily: 'Heebo',
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
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
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .fontSize),
                          obscureText: true,
                          decoration: InputDecoration(
                            labelStyle: TextStyle(height: .5),
                            hintStyle:
                                TextStyle(color: Colors.black.withOpacity(.25)),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
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
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .fontSize),
                          obscureText: true,
                          decoration: InputDecoration(
                            labelStyle: TextStyle(height: .5),
                            hintStyle:
                                TextStyle(color: Colors.black.withOpacity(.25)),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
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
                              //add a check to see if both passwords match or not
                              return 'Please enter a password with at least 6 keys';
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
                                      if (states
                                          .contains(MaterialState.disabled))
                                        return Colors.black.withOpacity(0.25);
                                      return Theme.of(context)
                                          .accentColor; // Defer to the widget's default.
                                    },
                                  ),
                                  elevation: MaterialStateProperty.all(0)),
                              onPressed: () {
                                // Validate will return true if the form is valid, or false if
                                // the form is invalid.
                                if (_formKey.currentState.validate()) {
                                  // Process data.
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) {
                                      return SignInScreen();
                                    }),
                                  );
                                }
                              },
                              child: const Text(
                                'Save New Password',
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
