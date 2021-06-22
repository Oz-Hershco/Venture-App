import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_moment/simple_moment.dart';
import 'package:venture_app/constants/functions.dart';
import 'package:venture_app/models/filter_item.dart';
import 'package:venture_app/models/user.dart';
import 'package:venture_app/models/venture.dart';
import 'package:venture_app/providers/user_provider.dart';
import 'package:venture_app/providers/users_provider.dart';
import 'package:venture_app/providers/venture_provider.dart';
import 'package:venture_app/providers/ventures_provider.dart';
import 'package:venture_app/screens/AddNewVentureScreen.dart';
import 'package:venture_app/screens/VentureScreen.dart';
import 'package:venture_app/widgets/CircularImage.dart';
import 'package:venture_app/widgets/CommentsSheet.dart';
import 'package:venture_app/widgets/ImageGridView.dart';
import 'package:venture_app/widgets/LikeBtn.dart';
import 'package:venture_app/widgets/LocationTagsControl/LocationTag.dart';
import 'package:venture_app/widgets/OptionsBottomSheet.dart';
import 'package:venture_app/widgets/SignInSuggestionDialog.dart';
import 'package:venture_app/widgets/Spinner.dart';

class VentureCard extends StatefulWidget {
  final Venture venture;
  final bool isExpanded;

  VentureCard({
    this.venture,
    this.isExpanded,
  });

  @override
  _VentureCardState createState() => _VentureCardState();
}

class _VentureCardState extends State<VentureCard> {
  _handleUserLike(bool isLiked) {
    final venturesData = Provider.of<VenturesProvider>(context, listen: false);
    final userData = Provider.of<UserProvider>(context, listen: false);
    final user = userData.item;
    if (user != null) {
      List<Venture> ventures = venturesData.list;
      Venture venture = ventures.firstWhere((v) => v.id == widget.venture.id);
      if (isLiked) {
        venture.likes.add(User(uid: user?.uid));
      } else {
        venture.likes.removeWhere((likeuser) => likeuser.uid == user?.uid);
      }
      venturesData.updateVenture(venture);
    } else {
      _showSignInSuggestionDialog();
    }
  }

  void _handleVentureRemove() {
    final venturesData = Provider.of<VenturesProvider>(context, listen: false);
    venturesData.removeVenture(widget.venture.id);
  }

  void _showVentureRemovalAlert() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        insetPadding: EdgeInsets.all(20),
        contentPadding:
            EdgeInsets.only(top: 15, bottom: 5, left: 18, right: 18),
        title: const Text(
          'Are you sure?',
          textAlign: TextAlign.center,
        ),
        content: Text(
          "You're about to delete '${widget.venture.title}' venture you published.This will remove any content related to this place, including comments, likes and pictures.",
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
                    'CANCEL',
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
                          return Theme.of(context).errorColor.withOpacity(
                              .75); // Defer to the widget's default.
                        },
                      ),
                      elevation: MaterialStateProperty.all(0)),
                  onPressed: () {
                    _handleVentureRemove();
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'REMOVE',
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
      ),
    );
  }

  void _handleVentureSaveUnsave() {
    final userData = Provider.of<UserProvider>(context, listen: false);
    final User user = userData.item;
    if (user != null) {
      if (user.savedVenturesList.contains(widget.venture.id)) {
        user.savedVenturesList
            .removeWhere((ventureId) => ventureId == widget.venture.id);
      } else {
        user.savedVenturesList.add(widget.venture.id);
      }
      userData.updateUser(user);
    }
  }

  void _showNavigationAlert() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        insetPadding: EdgeInsets.all(80),
        title: const Text('Navigate Using:'),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                launchWaze(widget.venture.position.latLng.latitude,
                    widget.venture.position.latLng.longitude);
              },
              child: Container(
                height: 35,
                margin: EdgeInsets.only(right: 5),
                child: new Image.asset(
                  'assets/images/waze_logo.png',
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                launchGoogleMaps(widget.venture.position.latLng.latitude,
                    widget.venture.position.latLng.longitude);
              },
              child: Container(
                height: 35,
                margin: EdgeInsets.only(right: 5),
                child: new Image.asset(
                  'assets/images/googlemaps_logo.png',
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showVentureOptionsSheet() {
    final userData = Provider.of<UserProvider>(context, listen: false);
    final User user = userData.item;

    bool userIsCreator = user != null && user.uid == widget.venture.creatorId;
    bool saveIsActive =
        user != null && user.savedVenturesList.contains(widget.venture.id);
    List<Map<String, dynamic>> options = [
      if (userIsCreator)
        {
          'leadingSrc': 'assets/images/trash_icon.png',
          'title': 'Remove',
          'subtitle': 'Delete entire venture including everything in it.',
        },
      if (userIsCreator)
        {
          'leadingSrc': 'assets/images/edit_icon.png',
          'title': 'Edit',
          'subtitle': 'Update the details of this venture.',
        },
      {
        'leadingSrc': 'assets/images/car_icon.png',
        'title': 'Navigate',
        'subtitle': 'Set course to this venture.',
      },
      if (user != null)
        {
          'leadingSrc': 'assets/images/bookmark_icon.png',
          'title': saveIsActive ? 'Unsave' : 'Save',
          'subtitle': saveIsActive
              ? 'Remove this site from your saved list'
              : 'Add this site to your saved list.',
          'active': saveIsActive,
        },
      // {
      //   'leadingSrc': 'assets/images/share_icon.png',
      //   'title': 'Share',
      //   'subtitle': 'Share this venture with others.',
      // },
    ];

    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: OptionsBottomSheet(
              options: options,
              onTap: (String title) {
                switch (title) {
                  case 'Navigate':
                    Navigator.of(context).pop();
                    _showNavigationAlert();
                    break;
                  case 'Remove':
                    Navigator.of(context).pop();
                    _showVentureRemovalAlert();
                    break;
                  case 'Save':
                  case 'Unsave':
                    Navigator.of(context).pop();
                    _handleVentureSaveUnsave();
                    break;
                  case 'Edit':
                    final ventureData =
                        Provider.of<VentureProvider>(context, listen: false);
                    ventureData.updateSingleVenture(widget.venture);
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed(
                      AddNewVentureScreen.routeName,
                      arguments: {'isEditMode': true},
                    );

                    break;
                  default:
                }
              },
            ),
          );
        });
  }

  _showVentureCommentsSheet() {
    final Venture venture = widget.venture;
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: CommentsSheet(venture),
          );
        });
  }

  void _showSignInSuggestionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => SignInSuggestionDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserProvider>(context, listen: false);

    final Venture venture = widget.venture;
    final bool isExpanded =
        widget.isExpanded != null ? widget.isExpanded : false;
    final User user = userData.item;

    final bool isLikeBtnActive =
        venture.likes.where((likeuser) => likeuser.uid == user?.uid).length > 0;
    List<FilterItem> filteredLocationFilters =
        venture.type.where((f) => f.isActive).toList();
    return Container(
      child: Column(
        children: [
          Container(
            child: Container(
              padding: EdgeInsets.only(top: 15, right: 15, left: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Card Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Header Left Side
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(13),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: .25,
                                color: Colors.black.withOpacity(.5),
                              ),
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.white,
                            ),
                            child: new Image.asset(
                              filteredLocationFilters[0].iconSrc,
                              color: Theme.of(context).primaryColor,
                              height: 18,
                              width: 18,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  venture.title,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Heebo',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  new Moment.fromDate(venture.timestamp)
                                      .format("MMMM dd yyy, HH:mm"),
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontFamily: 'Heebo',
                                    fontWeight: FontWeight.w300,
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      //Header Right Side
                      GestureDetector(
                        onTap: _showVentureOptionsSheet,
                        child: Container(
                          padding: EdgeInsets.all(5),
                          child: new Image.asset(
                            'assets/images/options_icon.png',
                            color: Colors.black.withOpacity(.5),
                            height: 18,
                            width: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  FutureBuilder(
                      future: Firestore.instance
                          .collection('users')
                          .document(venture.creatorId)
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Spinner(
                            color: Theme.of(context).primaryColor,
                            sizeWidth: 30,
                            sizeHeight: 30,
                            circleStrokeWidth: 3,
                          );
                        }
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              CircularImage(
                                imgSrc: snapshot.data['profilePic'],
                                margin: EdgeInsets.only(right: 5),
                                height: 35,
                                width: 35,
                              ),
                              Text(
                                snapshot.data['username'],
                                style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: 'Heebo',
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            ],
                          ),
                        );
                      }),
                  Text(
                    isExpanded
                        ? venture.description
                        : truncateString(venture.description, 110),
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'Heebo',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  if (isExpanded)
                    Wrap(
                      direction: Axis.horizontal,
                      children: venture.tags
                          .map((val) => LocationTag(
                                id: val.id,
                                name: val.name,
                              ))
                          .toList(),
                    ),
                  //Card Footer
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 5),
                        child: Row(
                          children: [
                            Container(
                              height: 15,
                              margin: EdgeInsets.only(right: 5),
                              child: new Image.asset(
                                'assets/images/pin_icon.png',
                                color: Colors.black.withOpacity(.5),
                              ),
                            ),
                            GestureDetector(
                              onTap: _showNavigationAlert,
                              child: Container(
                                width: 230,
                                child: Text(
                                  venture.position.address,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontFamily: 'Heebo',
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black.withOpacity(.5),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      if (!isExpanded)
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              VentureScreen.routeName,
                              arguments: {'ventureId': venture.id},
                            );
                          },
                          child: Text(
                            'View More',
                            style: TextStyle(
                              fontSize: 13,
                              fontFamily: 'Heebo',
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        )
                    ],
                  )
                ],
              ),
            ),
          ),
          if (venture.images.length > 0)
            ImageGridView(
              ventureId: venture.id,
              images: venture.images,
              providerType: 'ventures',
              includeEditOptions: false,
              galleryType: isExpanded ? 'column' : 'grid',
            ),
          Container(
            margin: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                venture.likes.length > 0
                    ? Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 3),
                            height: 15,
                            child: new Image.asset(
                              'assets/images/fullheart_icon.png',
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                          Text(
                            venture.likes.length.toString(),
                            style: TextStyle(
                              fontSize: 13,
                              fontFamily: 'Heebo',
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).accentColor,
                            ),
                          )
                        ],
                      )
                    : SizedBox(),
                if (venture.comments.length > 0)
                  GestureDetector(
                    onTap: _showVentureCommentsSheet,
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 3),
                          height: 15,
                          child: new Image.asset(
                            'assets/images/comments_icon.png',
                            color: Colors.black.withOpacity(.5),
                          ),
                        ),
                        Text(
                          '${venture.comments.length.toString()} Comments',
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: 'Heebo',
                            fontWeight: FontWeight.w400,
                            color: Colors.black.withOpacity(.5),
                          ),
                        )
                      ],
                    ),
                  ),
              ],
            ),
          ),
          Container(
            color: Colors.black.withOpacity(.75),
            height: .25,
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                LikeBtn(
                  isActive: isLikeBtnActive,
                  onTap: _handleUserLike,
                ),
                GestureDetector(
                  onTap: _showVentureCommentsSheet,
                  child: Container(
                    height: 50,
                    width: 180,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 7),
                          height: 16,
                          child: new Image.asset(
                            'assets/images/comment_icon.png',
                            color: Colors.black.withOpacity(.5),
                          ),
                        ),
                        Text(
                          'Comment',
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Heebo',
                            fontWeight: FontWeight.w400,
                            color: Colors.black.withOpacity(.5),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.black.withOpacity(.05),
            height: 10,
          )
        ],
      ),
    );
  }
}
