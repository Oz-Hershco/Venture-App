import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:venture_app/models/venture.dart';
import 'package:venture_app/providers/venture_provider.dart';
import 'package:venture_app/providers/ventures_provider.dart';
import 'package:venture_app/widgets/VentureImage.dart';

class ImageGallery extends StatefulWidget {
  static const routeName = '/image-gallery';
  @override
  _ImageGalleryState createState() => _ImageGalleryState();
}

class _ImageGalleryState extends State<ImageGallery> {
  int selectedImageIndex = 0;
  final ImagePicker picker = ImagePicker();
  _handleImageSelect(int index) {
    setState(() {
      selectedImageIndex = index;
    });
  }

  _imgFromGalleryOrCamera(
      {String ventureId, String providerType, ImageSource imageSource}) async {
    final pickedFile = await picker.getImage(source: imageSource);
    if (pickedFile != null) {
      final venturesData =
          Provider.of<VenturesProvider>(context, listen: false);
      final ventureData = Provider.of<VentureProvider>(context, listen: false);
      final Venture venture = ventureData.item;
      final List<Venture> ventures = venturesData.list;
      switch (providerType) {
        case 'venture':
          venture.images.replaceRange(
              selectedImageIndex, selectedImageIndex + 1, [pickedFile.path]);
          venture.images.join(', ');
          ventureData.updateSingleVenture(venture);
          break;
        case 'ventures':
          ventures.forEach((v) {
            if (v.id == ventureId) {
              v.images.replaceRange(selectedImageIndex, selectedImageIndex + 1,
                  [pickedFile.path]);
              v.images.join(', ');
            }
          });

          venturesData.updateVentures(ventures);
          break;
        default:
      }
    } else {
      print('No image selected.');
    }
  }

  void _showReplaceImagePicker({
    BuildContext context,
    String ventureId,
    dynamic providerType,
  }) {
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
                          ventureId: ventureId,
                          providerType: providerType,
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
                        ventureId: ventureId,
                        providerType: providerType,
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

  _handleImageRemove({
    String ventureId,
    List<String> images,
    dynamic providerType,
  }) {
    final venturesData = Provider.of<VenturesProvider>(context, listen: false);
    final ventureData = Provider.of<VentureProvider>(context, listen: false);
    final List<Venture> ventures = venturesData.list;
    Venture venture = ventures.firstWhere((v) => v.id == ventureId);
    switch (providerType) {
      case 'venture':
        ventureData.removeSingleVentureImage(selectedImageIndex);
        break;
      case 'ventures':
        venture.images.removeAt(selectedImageIndex);
        venturesData.updateVenture(venture);
        break;
      default:
    }
    if (selectedImageIndex > 0) {
      setState(() {
        selectedImageIndex = selectedImageIndex - 1;
      });
    } else if (images.length == 0) {
      Navigator.of(context).pop();
    }
  }

  _handleImageSwipeNavigation(e, images) {
    if (e.velocity.pixelsPerSecond.dx > 0) {
      if (selectedImageIndex > 0) {
        setState(() {
          selectedImageIndex--;
        });
      }
    } else {
      if (selectedImageIndex < images.length - 1) {
        setState(() {
          selectedImageIndex++;
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    final ventureId = routeArgs['ventureId'];
    final includeEditOptions = routeArgs['includeEditOptions'];
    final providerType = routeArgs['providerType'];
    final venturesData = Provider.of<VenturesProvider>(context);
    final ventureData = Provider.of<VentureProvider>(context);
    Venture currentVenture;
    switch (providerType) {
      case 'venture':
        currentVenture = ventureData.item;
        break;
      case 'ventures':
        currentVenture =
            venturesData.list.where((v) => v.id == ventureId).toList()[0];
        break;
      default:
    }
    final images = currentVenture.images;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (includeEditOptions)
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    images.length > 1
                        ? GestureDetector(
                            onTap: () {
                              _handleImageRemove(
                                ventureId: ventureId,
                                images: images,
                                providerType: providerType,
                              );
                            },
                            child: Row(
                              children: [
                                Container(
                                  height: 14,
                                  margin: EdgeInsets.only(right: 5),
                                  child: new Image.asset(
                                    'assets/images/trash_icon.png',
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'Delete',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15),
                                )
                              ],
                            ),
                          )
                        : SizedBox(),
                    GestureDetector(
                      onTap: () {
                        _showReplaceImagePicker(
                          context: context,
                          ventureId: ventureId,
                          providerType: providerType,
                        );
                      },
                      child: Row(
                        children: [
                          Container(
                            height: 14,
                            margin: EdgeInsets.only(right: 5),
                            child: new Image.asset(
                              'assets/images/refresh_icon.png',
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Replace',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            // ...widget.filesList.map(
            //   (src) => Expanded(
            //     child: Image.file(
            //       src,
            //       fit: BoxFit.cover,
            //       height: 130,
            //     ),
            //   ),
            // )
            if (images.length > 0)
              GestureDetector(
                onHorizontalDragEnd: (e) {
                  _handleImageSwipeNavigation(e, images);
                },
                child: Expanded(
                  child: VentureImage(
                    imageContainerHeight:
                        MediaQuery.of(context).size.height * 0.75,
                    type: images[selectedImageIndex].contains('http')
                        ? 'network'
                        : 'file',
                    src: images[selectedImageIndex],
                    file: File(images[selectedImageIndex]),
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),

            Container(
              margin: EdgeInsets.only(bottom: 20, left: 20, right: 20),
              height: 80,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  ...images
                      .asMap()
                      .map(
                        (index, src) => MapEntry(
                            index,
                            GestureDetector(
                              onTap: () {
                                _handleImageSelect(index);
                              },
                              child: Container(
                                margin: EdgeInsets.only(right: 5),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: index == selectedImageIndex
                                        ? Colors.white
                                        : Colors.black,
                                    width: 2,
                                  ),
                                ),
                                child: VentureImage(
                                  type:
                                      src.contains('http') ? 'network' : 'file',
                                  src: src,
                                  file: File(src),
                                  imageWidth: 120,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )),
                      )
                      .values
                      .toList()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
