import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:venture_app/providers/venture_provider.dart';

class AddImagesBtn extends StatefulWidget {
  final List<String> images;
  AddImagesBtn({this.images});
  @override
  _AddImagesBtnState createState() => _AddImagesBtnState();
}

class _AddImagesBtnState extends State<AddImagesBtn> {

  final ImagePicker picker = ImagePicker();

  _imgFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    if (pickedFile != null) {
      final ventureData = Provider.of<VentureProvider>(context, listen: false);
      ventureData.addSingleVentureImage(pickedFile.path);
    } else {
      print('No image selected.');
    }
  }

  _imgFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final ventureData = Provider.of<VentureProvider>(context, listen: false);
      ventureData.addSingleVentureImage(pickedFile.path);
    } else {
      print('No image selected.');
    }
  }

  void _showImagePicker(context) {
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
                        _imgFromGallery();
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
                      _imgFromCamera();
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
    List<String> images = widget.images;
    return  Container(
                    width: images.length > 0 ? 185 : 150,
                    margin: EdgeInsets.only(top: 20),
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.disabled))
                                return Colors.black.withOpacity(0.25);
                              return Theme.of(context)
                                  .primaryColorLight; // Defer to the widget's default.
                            },
                          ),
                          elevation: MaterialStateProperty.all(0)),
                      onPressed: () {
                        _showImagePicker(context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 13,
                            margin: EdgeInsets.only(right: 10),
                            child: new Image.asset(
                              'assets/images/image_icon.png',
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            images.length > 0
                                ? 'ADD MORE IMAGES'
                                : 'ADD IMAGES',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
  }
}
