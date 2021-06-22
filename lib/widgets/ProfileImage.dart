import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:venture_app/providers/user_provider.dart';
import 'package:venture_app/widgets/CircularImage.dart';

class ProfileImage extends StatefulWidget {
  final String imgSrc;
  final Function onTap;
  final Function onFileChange;
  final String buttonLabelText;
  ProfileImage({
    @required this.imgSrc,
    this.onTap,
    this.onFileChange,
    this.buttonLabelText,
  });
  @override
  _ProfileImageState createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
  final ImagePicker picker = ImagePicker();

  _imgFromGalleryOrCamera({ImageSource imageSource}) async {
    final pickedFile = await picker.getImage(source: imageSource);

    if (pickedFile != null && widget.onFileChange != null) {
      setState(() {
        widget.onFileChange(pickedFile.path);
      });
    } else {
      print('No image selected.');
    }
  }

  void _showImagePicker() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      minVerticalPadding: 0,
                      minLeadingWidth: 5,
                      leading: new Icon(
                        Icons.photo_library,
                        color: Theme.of(context).primaryColorLight,
                      ),
                      title: new Text(
                        'Photo Library',
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Heebo',
                          color: Theme.of(context).primaryColorLight,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      onTap: () {
                        _imgFromGalleryOrCamera(
                          imageSource: ImageSource.gallery,
                        );
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    minVerticalPadding: 0,
                    minLeadingWidth: 5,
                    leading: new Icon(
                      Icons.photo_camera,
                      color: Theme.of(context).primaryColorLight,
                    ),
                    title: new Text(
                      'Camera',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Heebo',
                        color: Theme.of(context).primaryColorLight,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    onTap: () {
                      _imgFromGalleryOrCamera(
                        imageSource: ImageSource.camera,
                      );

                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    String imgSrc = widget.imgSrc;
    Function onFileChange = widget.onFileChange;
    String buttonLabelText = widget.buttonLabelText;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: onFileChange != null ? _showImagePicker : null,
              child: CircularImage(
                imgSrc: imgSrc,
                margin: EdgeInsets.only(bottom: 5),
                height: 160,
                width: 160,
              ),
            ),
          ],
        ),
        if (buttonLabelText != null && buttonLabelText.length > 0)
          GestureDetector(
            onTap: onFileChange != null ? _showImagePicker : null,
            child: Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 20),
              child: Text(
                buttonLabelText,
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'Heebo',
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).primaryColorLight,
                ),
              ),
            ),
          )
      ],
    );
  }
}
