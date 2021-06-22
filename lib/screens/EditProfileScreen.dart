import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:venture_app/models/user.dart';
import 'package:venture_app/providers/user_provider.dart';
import 'package:venture_app/providers/users_provider.dart';
import 'package:venture_app/widgets/ProfileImage.dart';
import 'package:venture_app/widgets/Spinner.dart';

class EditProfileScreen extends StatefulWidget {
  static const routeName = '/edit-profile';

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final displaynameTextController = TextEditingController();
  final aboutDetailsTextController = TextEditingController();
  String profileImageSrc = "";
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      final userData = Provider.of<UserProvider>(context, listen: false);
      final User user = userData.item;
      displaynameTextController.text = user.name;
      aboutDetailsTextController.text = user.about;
      profileImageSrc = user.profilePic;
    });
  }

  _saveValidation() {
    return displaynameTextController.text.length > 0;
  }

  _handleSaveProfile() async {
    setState(() {
      _isLoading = true;
    });
    final userData = Provider.of<UserProvider>(context, listen: false);
    final User user = userData.item;

    try {
      final User newUserData = User(
        uid: user.uid,
        name: displaynameTextController.text,
        about: aboutDetailsTextController.text,
        profilePic: profileImageSrc,
        savedVenturesList: user.savedVenturesList,
      );

      final ref = FirebaseStorage.instance
          .ref()
          .child('user_image')
          .child(user.uid + '.jpg');
      final uploadedFile = await ref.putFile(File(profileImageSrc)).onComplete;
      final String downloadUrl = await uploadedFile.ref.getDownloadURL();
      user.profilePic.replaceAll(user.profilePic, downloadUrl.split("?")[0]);

      userData.updateUser(newUserData);
    } catch (error) {
      throw error;
    }

    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  _handleOnProfilePicChange(String pickedFilePath) {
    setState(() {
      profileImageSrc = pickedFilePath;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomSheet: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(width: .5, color: Colors.black.withAlpha(75)),
              ),
            ),
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 100),
            child: Container(
              width: 150,
              height: 45,
              margin: EdgeInsets.symmetric(vertical: 15),
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.disabled))
                          return Colors.black.withOpacity(0.25);
                        return Theme.of(context)
                            .accentColor; // Defer to the widget's default.
                      },
                    ),
                    elevation: MaterialStateProperty.all(0)),
                onPressed: _saveValidation() ? _handleSaveProfile : null,
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'SAVE',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Heebo',
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
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
          'Edit Profile',
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
              color: Theme.of(context).primaryColor,
              sizeWidth: 30,
              sizeHeight: 30,
              circleStrokeWidth: 3,
            )
          : SingleChildScrollView(
              child: Container(
                margin:
                    EdgeInsets.only(left: 20, right: 20, top: 40, bottom: 90),
                child: Column(
                  children: [
                    ProfileImage(
                      imgSrc: profileImageSrc,
                      onFileChange: _handleOnProfilePicChange,
                      buttonLabelText: 'CHANGE PROFILE PICTURE',
                    ),
                    TextField(
                      controller: displaynameTextController,
                      style: TextStyle(
                        fontFamily:
                            Theme.of(context).textTheme.bodyText1.fontFamily,
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(15),
                        fillColor: Colors.white,
                        filled: true,
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        hintText: "Add a display name*",
                        alignLabelWithHint: true,
                        hintStyle: TextStyle(
                            fontFamily: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .fontFamily,
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: Colors.black.withAlpha(75)),
                        labelText: "Add a display name*",
                        labelStyle: TextStyle(
                            fontFamily: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .fontFamily,
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: Colors.black.withAlpha(75)),
                        enabledBorder: OutlineInputBorder(
                          borderSide: new BorderSide(
                              width: .5, color: Colors.black.withAlpha(75)),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: new BorderSide(
                              width: .5, color: Colors.black.withAlpha(75)),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: aboutDetailsTextController,
                      keyboardType: TextInputType.multiline,
                      minLines: 5,
                      maxLines: null,
                      style: TextStyle(
                        fontFamily:
                            Theme.of(context).textTheme.bodyText1.fontFamily,
                        fontWeight: FontWeight.w300,
                        fontSize: 16,
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(15),
                        fillColor: Colors.white,
                        filled: true,
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        hintText: "Tell everyone about yourself (optional)",
                        alignLabelWithHint: true,
                        hintStyle: TextStyle(
                            fontFamily: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .fontFamily,
                            fontWeight: FontWeight.w300,
                            fontSize: 16,
                            color: Colors.black.withAlpha(75)),
                        labelText: "Tell everyone about yourself (optional)",
                        labelStyle: TextStyle(
                            fontFamily: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .fontFamily,
                            fontWeight: FontWeight.w300,
                            fontSize: 16,
                            color: Colors.black.withAlpha(75)),
                        enabledBorder: OutlineInputBorder(
                          borderSide: new BorderSide(
                              width: .5, color: Colors.black.withAlpha(75)),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: new BorderSide(
                              width: .5, color: Colors.black.withAlpha(75)),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
